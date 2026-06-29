import 'package:get/get.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../data/models/accessory_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/checkout_model.dart';
import '../../data/repositories/store_repository.dart';

class StoreController extends GetxController {
  final StoreRepository _repository = StoreRepository();

  // ── State ──────────────────────────────────────────────────────────────
  final RxList<AccessoryModel> accessories = <AccessoryModel>[].obs;
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  // Details state
  final Rx<AccessoryModel?> selectedAccessory = Rx<AccessoryModel?>(null);
  final RxBool isLoadingDetails = false.obs;
  final RxString detailsError = ''.obs;

  // Cart state
  final RxBool isLoadingCart = false.obs;
  final RxString cartError = ''.obs;

  // Tracks which accessory IDs have an in-flight API call
  final RxSet<int> addingToCartIds = <int>{}.obs;

  // Checkout state
  final RxBool isCheckingOut = false.obs;
  final Rx<CheckoutResponseModel?> lastCheckoutResult =
      Rx<CheckoutResponseModel?>(null);

  // ── Computed ────────────────────────────────────────────────────────────
  List<AccessoryModel> get filteredAccessories {
    if (searchQuery.value.isEmpty) return accessories;
    final q = searchQuery.value.toLowerCase();
    return accessories
        .where(
          (a) =>
              a.name.toLowerCase().contains(q) ||
              a.description.toLowerCase().contains(q),
        )
        .toList();
  }

  int get cartCount => cartItems.fold(0, (sum, i) => sum + i.quantity);
  double get cartTotal => cartItems.fold(0.0, (sum, i) => sum + i.totalPrice);

  // ── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchAccessories();
  }

  // ── Fetch Accessories ────────────────────────────────────────────────────
  Future<void> fetchAccessories() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _repository.getAllAccessories();
      accessories.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch Accessory Details ───────────────────────────────────────────
  Future<void> fetchAccessoryDetails(int id, {AccessoryModel? initial}) async {
    selectedAccessory.value = initial;
    isLoadingDetails.value = true;
    detailsError.value = '';
    try {
      final result = await _repository.getAccessoryDetails(id);
      selectedAccessory.value = result;
    } catch (e) {
      detailsError.value = e.toString().replaceFirst('Exception: ', '');
      AppSnackbar.error(detailsError.value);
    } finally {
      isLoadingDetails.value = false;
    }
  }

  // ── Fetch Cart (GET /cart) ────────────────────────────────────────────
  Future<void> fetchCart() async {
    isLoadingCart.value = true;
    cartError.value = '';
    try {
      final apiItems = await _repository.getCart();
      final enriched = apiItems.map((item) {
        final full = accessories.firstWhereOrNull(
          (a) => a.id == item.accessory.id,
        );
        return CartItemModel(
          cartItemId: item.cartItemId,
          accessory: full ?? item.accessory,
          quantity: item.quantity,
        );
      }).toList();
      cartItems.assignAll(enriched);
    } catch (e) {
      cartError.value = e.toString().replaceFirst('Exception: ', '');
      AppSnackbar.error(cartError.value);
    } finally {
      isLoadingCart.value = false;
    }
  }

  // ── Add to Cart — from product list/details (POST /cart qty:1) ───────
  Future<void> addToCart(AccessoryModel accessory) async {
    final existing = cartItems.firstWhereOrNull(
      (i) => i.accessory.id == accessory.id,
    );

    addingToCartIds.add(accessory.id);
    try {
      final response = await _repository.addToCart(
        accessoryId: accessory.id,
        quantity: 1,
      );
      if (existing != null) {
        // Server already has it — update local quantity and refresh cartItemId
        existing.quantity++;
        existing.cartItemId = response.id;
        cartItems.refresh();
      } else {
        cartItems.add(
          CartItemModel(
            cartItemId: response.id,
            accessory: accessory,
            quantity: 1,
          ),
        );
      }
      AppSnackbar.success('تمت الإضافة إلى السلة');
    } catch (e) {
      AppSnackbar.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      addingToCartIds.remove(accessory.id);
    }
  }

  bool isAddingToCart(int accessoryId) => addingToCartIds.contains(accessoryId);

  // ── Increase (+) — POST /cart with quantity:1 ────────────────────────
  // Server accumulates: existing qty + 1
  Future<void> increaseQuantity(int accessoryId) async {
    final item = cartItems.firstWhereOrNull(
      (i) => i.accessory.id == accessoryId,
    );
    if (item == null) return;
    if (addingToCartIds.contains(accessoryId)) return; // prevent double tap

    addingToCartIds.add(accessoryId);
    try {
      final response = await _repository.addToCart(
        accessoryId: accessoryId,
        quantity: 1,
      );
      item.quantity++;
      item.cartItemId = response.id;
      cartItems.refresh();
    } catch (e) {
      AppSnackbar.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      addingToCartIds.remove(accessoryId);
    }
  }

  // ── Decrease (-) ─────────────────────────────────────────────────────
  // qty = 1 → DELETE /cart/{id}   (remove entirely)
  // qty > 1 → DELETE then POST    (remove old, re-add with qty-1)
  Future<void> decreaseQuantity(int accessoryId) async {
    final item = cartItems.firstWhereOrNull(
      (i) => i.accessory.id == accessoryId,
    );
    if (item == null) return;
    if (addingToCartIds.contains(accessoryId)) return; // prevent double tap

    addingToCartIds.add(accessoryId);
    try {
      if (item.quantity <= 1) {
        // ── Remove entirely ─────────────────────────────────────────
        await _repository.deleteCartItem(item.cartItemId);
        cartItems.remove(item);
      } else {
        // ── Decrease by 1: delete current row, re-add with newQty ───
        final newQty = item.quantity - 1;
        await _repository.deleteCartItem(item.cartItemId);
        final response = await _repository.addToCart(
          accessoryId: accessoryId,
          quantity: newQty,
        );
        item.quantity = newQty;
        item.cartItemId = response.id; // new row ID from server
        cartItems.refresh();
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      addingToCartIds.remove(accessoryId);
    }
  }

  // ── Remove (delete icon) — DELETE /cart/{id} ─────────────────────────
  Future<void> removeFromCart(int accessoryId) async {
    final item = cartItems.firstWhereOrNull(
      (i) => i.accessory.id == accessoryId,
    );
    if (item == null) return;

    if (item.cartItemId == 0) {
      cartItems.remove(item);
      return;
    }

    addingToCartIds.add(accessoryId);
    try {
      await _repository.deleteCartItem(item.cartItemId);
      cartItems.remove(item);
    } catch (e) {
      AppSnackbar.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      addingToCartIds.remove(accessoryId);
    }
  }

  // ── Checkout — POST /checkout ─────────────────────────────────────────
  /// Returns true on success, false on failure.
  Future<bool> checkout({required String paymentMethod}) async {
    if (isCheckingOut.value) return false;
    isCheckingOut.value = true;
    try {
      final result = await _repository.checkout(paymentMethod: paymentMethod);
      lastCheckoutResult.value = result;
      clearCart();
      return true;
    } catch (e) {
      AppSnackbar.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isCheckingOut.value = false;
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────
  void clearCart() => cartItems.clear();

  bool isInCart(int accessoryId) =>
      cartItems.any((item) => item.accessory.id == accessoryId);

  void updateSearch(String query) => searchQuery.value = query;
}
