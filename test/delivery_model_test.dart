import 'package:flutter_test/flutter_test.dart';
import 'package:shamsoung/featurs/deliveries/data/models/delivery_model.dart';

void main() {
  group('DeliveryModel parsing', () {
    test('parses delivery fields from API response payload', () {
      final json = {
        'id': 54,
        'type': 'accessory_delivery',
        'payment_method': 'cash_on_delivery',
        'delivery_worker_id': 2,
        'customer_id': 16,
        'shop_id': 1,
        'latitude': '33.5148050',
        'longitude': '36.2521470',
        'address': null,
        'maintenance_request_id': null,
        'order_id': 42,
        'status': 'accepted',
        'notes': 'Please call before arrival',
        'estimated_time': '2026-07-22T14:27:59.000000Z',
        'confirmation_code': null,
        'confirmation_image_path': null,
        'confirmed_at': null,
        'cash_collected': false,
        'cash_amount': null,
        'created_at': '2026-07-22T10:48:29.000000Z',
        'updated_at': '2026-07-22T10:56:30.000000Z',
        'delivery_worker': {
          'id': 2,
          'first_name': 'احمد',
          'last_name': 'ايوب',
        },
        'shop': {
          'id': 1,
          'name': 'Al-Mazzah Main Center',
          'address': 'Al-Mazzah Highway, Damascus',
          'latitude': 33.507328,
          'longitude': 36.27303,
        },
      };

      final model = DeliveryModel.fromJson(json);

      expect(model.id, 54);
      expect(model.type, 'accessory_delivery');
      expect(model.paymentMethod, 'cash_on_delivery');
      expect(model.orderId, 42);
      expect(model.notes, 'Please call before arrival');
      expect(model.deliveryWorker?.fullName, 'احمد ايوب');
      expect(model.shop?.name, 'Al-Mazzah Main Center');
      expect(model.shop?.address, 'Al-Mazzah Highway, Damascus');
    });
  });
}
