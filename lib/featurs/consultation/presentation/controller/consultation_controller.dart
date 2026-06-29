import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/consultation_model.dart';
import '../../data/repositories/consultation_repository.dart';

class ConsultationController extends GetxController {
  final ConsultationRepository _repository = ConsultationRepository();
  final StorageService _storage = StorageService();

  // ── القائمة المرئية للـ cards (بعد إخفاء الرسائل الإضافية) ──
  final RxList<ConsultationModel> consultations = <ConsultationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;

  // ── IDs الاستشارات المخفية (أُنشئت كرسائل إضافية) ──────────
  // تُحفظ في GetStorage حتى تبقى بعد إعادة تشغيل التطبيق
  final Set<int> _hiddenIds = {};

  // ── الاستشارة النشطة ──────────────────────────────────────
  final Rx<ConsultationModel?> activeConsultation = Rx<ConsultationModel?>(
    null,
  );

  // ── Thread messages per root card id ─────────────────────
  final Map<int, RxList<ChatMessage>> _threads = {};

  RxList<ChatMessage> get activeMessages {
    final id = _rootCardId;
    if (id == null) return <ChatMessage>[].obs;
    return _threads.putIfAbsent(id, () => <ChatMessage>[].obs);
  }

  // id الـ card الجذر للمحادثة المفتوحة — لا يتغير أثناء المحادثة
  int? _rootCardId;

  // ── Form ──────────────────────────────────────────────────
  final TextEditingController messageController = TextEditingController();
  final RxString selectedType = 'ai'.obs;

  // ── Scroll ────────────────────────────────────────────────
  final ScrollController scrollController = ScrollController();

  // ── Polling ───────────────────────────────────────────────
  Timer? _pollingTimer;
  static const _pollingInterval = Duration(seconds: 5);

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // حمِّل IDs المخفية من الـ storage أولاً
    _hiddenIds.addAll(_storage.loadHiddenConsultationIds());
    fetchConsultations();
  }

  @override
  void onClose() {
    _stopPolling();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ── Public ────────────────────────────────────────────────

  void selectType(String type) => selectedType.value = type;

  /// حذف محادثة من القائمة (محلياً فقط — الـ API لا يدعم الحذف)
  void deleteConsultation(int id) {
    consultations.removeWhere((c) => c.id == id);
    // أضفه للـ hiddenIds حتى لا يعود عند refresh
    _hideConsultation(id);
    // امسح الـ thread والـ storage
    _threads.remove(id);
    _storage.clearThread(id);
  }

  /// فتح chat جديد فارغ (FAB)
  void resetChat() {
    _stopPolling();
    _saveCurrentThread();
    activeConsultation.value = null;
    _rootCardId = null;
    messageController.clear();
    selectedType.value = 'ai';
  }

  /// فتح chat استشارة موجودة (من card)
  void openConsultation(ConsultationModel c) {
    _stopPolling();
    _saveCurrentThread();

    final latest = consultations.firstWhereOrNull((x) => x.id == c.id) ?? c;
    activeConsultation.value = latest;
    _rootCardId = latest.id;
    messageController.clear();
    selectedType.value = latest.consultationType;

    // حمِّل الـ thread المحفوظ
    final thread = _threads.putIfAbsent(latest.id, () => <ChatMessage>[].obs);
    if (thread.isEmpty) {
      _loadThread(latest.id, thread, latest);
    }

    // polling للتقني إذا لم يُجب بعد
    if (!latest.isAi && latest.isPending) {
      _startPolling(latest.id);
    }

    _scrollToBottom();
  }

  Future<void> fetchConsultations() async {
    try {
      isLoading.value = true;
      final result = await _repository.getMyConsultations();

      // أخفِ الاستشارات التي أُنشئت كرسائل إضافية
      final visible = result.where((c) => !_hiddenIds.contains(c.id)).toList();

      consultations.assignAll(visible);
    } catch (e) {
      debugPrint('fetchConsultations error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// إرسال رسالة — نفس اللوجك للأولى وما بعدها
  Future<void> submitConsultation() async {
    final msg = messageController.text.trim();
    if (msg.isEmpty) {
      AppSnackbar.error('Please enter your question first');
      return;
    }

    messageController.clear();
    final isFirstMessage = activeConsultation.value == null;

    // ── للرسالة الأولى: ننشئ thread مؤقت بـ key خاص ─────────
    // لأن _rootCardId لا يزال null، نستخدم key مؤقت = -1
    if (isFirstMessage) {
      _rootCardId = -1; // مؤقت حتى يصل الـ id الحقيقي من الـ API
      _threads[-1] = <ChatMessage>[].obs;
    }

    final thread = activeMessages;

    // bubble السؤال فوراً (optimistic)
    thread.add(ChatMessage(text: msg, isFromUser: true, time: DateTime.now()));
    _scrollToBottom();

    // typing indicator
    thread.add(
      ChatMessage(
        text: '',
        isFromUser: false,
        time: DateTime.now(),
        isPending: true,
      ),
    );
    _scrollToBottom();

    try {
      isSending.value = true;
      _stopPolling();

      final typeToSend =
          activeConsultation.value?.consultationType ?? selectedType.value;

      final created = await _repository.createConsultation(
        consultationType: typeToSend,
        message: msg,
      );

      // أزل typing indicator
      thread.removeWhere((m) => m.isPending);

      if (isFirstMessage) {
        // انقل الـ thread المؤقت (-1) للـ id الحقيقي
        final messages = List<ChatMessage>.from(thread);
        _threads.remove(-1);
        _rootCardId = created.id;
        final realThread = _threads.putIfAbsent(
          created.id,
          () => <ChatMessage>[].obs,
        );
        realThread.addAll(messages);

        activeConsultation.value = created;

        // أضف الـ card للقائمة المرئية
        if (!consultations.any((c) => c.id == created.id)) {
          consultations.insert(0, created);
        }
      } else {
        // رسالة إضافية → أخفِ الاستشارة الجديدة من القائمة
        _hideConsultation(created.id);
      }

      // الـ thread الحقيقي الآن
      final realThread = activeMessages;

      if (created.isAnswered) {
        realThread.add(
          ChatMessage(
            text: created.reply!,
            isFromUser: false,
            time: DateTime.now(),
          ),
        );
        _scrollToBottom();
        _updateRootCard(created);
      } else {
        realThread.add(
          ChatMessage(
            text: '',
            isFromUser: false,
            time: DateTime.now(),
            isPending: true,
          ),
        );
        _scrollToBottom();
        _startPolling(created.id);
      }

      _saveCurrentThread();
    } catch (e) {
      thread.removeWhere((m) => m.isPending);
      thread.add(
        ChatMessage(
          text: '⚠ Failed to send. Please try again.',
          isFromUser: false,
          time: DateTime.now(),
        ),
      );
      if (isFirstMessage) _rootCardId = null;
      debugPrint('submitConsultation error: $e');
    } finally {
      isSending.value = false;
    }
  }

  // ── Polling ───────────────────────────────────────────────

  void _startPolling(int consultationId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) async {
      await _pollForReply(consultationId);
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _pollForReply(int consultationId) async {
    try {
      final list = await _repository.getMyConsultations();
      final updated = list.firstWhereOrNull((c) => c.id == consultationId);
      if (updated == null || !updated.isAnswered) return;

      _stopPolling();

      final thread = _threads[_rootCardId];
      if (thread == null) return;

      // أزل pending bubble وأضف الرد
      thread.removeWhere((m) => m.isPending);
      thread.add(
        ChatMessage(
          text: updated.reply!,
          isFromUser: false,
          time: DateTime.now(),
        ),
      );

      // حدِّث الـ card الأصلية
      _updateRootCard(updated);

      _saveCurrentThread();
      _scrollToBottom();
    } catch (e) {
      debugPrint('polling error: $e');
    }
  }

  // ── Helpers ───────────────────────────────────────────────

  /// يُضيف ID للقائمة المخفية ويحفظها
  void _hideConsultation(int id) {
    _hiddenIds.add(id);
    _storage.saveHiddenConsultationIds(_hiddenIds);

    // أزلها من القائمة المرئية إن ظهرت
    consultations.removeWhere((c) => c.id == id);
  }

  /// يحدِّث بيانات الـ card الأصلية في القائمة المرئية
  void _updateRootCard(ConsultationModel updated) {
    if (_rootCardId == null) return;
    final idx = consultations.indexWhere((c) => c.id == _rootCardId);
    if (idx >= 0) {
      // حدِّث فقط reply وstatus مع الاحتفاظ ببقية البيانات
      consultations[idx] = updated.copyWith(
        status: updated.status,
        reply: updated.reply,
      );
    }
  }

  void _saveCurrentThread() {
    final id = _rootCardId;
    if (id == null) return;
    final thread = _threads[id];
    if (thread == null) return;

    final toSave = thread
        .where((m) => !m.isPending)
        .map((m) => m.toJson())
        .toList();

    _storage.saveThread(id, toSave);
  }

  void _loadThread(
    int id,
    RxList<ChatMessage> thread,
    ConsultationModel model,
  ) {
    final saved = _storage.loadThread(id);

    if (saved.isNotEmpty) {
      thread.addAll(saved.map((j) => ChatMessage.fromJson(j)));

      // أعِد pending bubble إذا التقني لم يُجب بعد
      if (!model.isAi && model.isPending) {
        thread.add(
          ChatMessage(
            text: '',
            isFromUser: false,
            time: DateTime.now(),
            isPending: true,
          ),
        );
      }
    } else {
      _seedThread(thread, model);
    }
  }

  void _seedThread(RxList<ChatMessage> thread, ConsultationModel c) {
    thread.add(
      ChatMessage(
        text: c.message,
        isFromUser: true,
        time: DateTime.tryParse(c.createdAt) ?? DateTime.now(),
      ),
    );
    if (c.isAnswered) {
      thread.add(
        ChatMessage(
          text: c.reply!,
          isFromUser: false,
          time: DateTime.tryParse(c.updatedAt) ?? DateTime.now(),
        ),
      );
    } else if (!c.isAi) {
      thread.add(
        ChatMessage(
          text: '',
          isFromUser: false,
          time: DateTime.now(),
          isPending: true,
        ),
      );
    }
    _saveCurrentThread();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
