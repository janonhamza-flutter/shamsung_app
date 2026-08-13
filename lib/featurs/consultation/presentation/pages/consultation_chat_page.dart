import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../data/models/consultation_model.dart';
import '../controller/consultation_controller.dart';
import '../widgets/consultation_type_selector.dart';

/// Returns [darkColor] unchanged in Dark Mode; in Light Mode returns
/// [lightColor], a deepened variant tuned for legibility on light surfaces.
/// Used to distinguish "AI" vs "technician" — a decorative pairing that
/// doesn't map onto the semantic palette fields.
Color _typeAccent(BuildContext context, bool isAi) {
  if (isAi) {
    return context.colors.isDark
        ? Colors.purpleAccent
        : const Color(0xFF7B1FA2);
  }
  return context.colors.isDark ? Colors.blueAccent : const Color(0xFF1565C0);
}

class ConsultationChatPage extends StatefulWidget {
  final ConsultationModel? initialConsultation;

  const ConsultationChatPage({super.key, this.initialConsultation});

  @override
  State<ConsultationChatPage> createState() => _ConsultationChatPageState();
}

class _ConsultationChatPageState extends State<ConsultationChatPage> {
  late final ConsultationController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.find<ConsultationController>();
    if (widget.initialConsultation != null) {
      ctrl.openConsultation(widget.initialConsultation!);
    } else {
      ctrl.resetChat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        title: Obx(() {
          final c = ctrl.activeConsultation.value;
          if (c == null) {
            return Text('new_consultation'.tr, style: _titleStyle(context));
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                c.isAi ? Icons.smart_toy_outlined : Icons.engineering_outlined,
                color: _typeAccent(context, c.isAi),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                c.isAi ? 'ai_assistant'.tr : 'technician'.tr,
                style: _titleStyle(context),
              ),
            ],
          );
        }),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: context.colors.textPrimary,
          ),
          onPressed: () {
            ctrl.resetChat();
            Get.back();
          },
        ),
        actions: const [],
      ),

      body: Column(
        children: [
          // ── Type selector (للاستشارة الجديدة قبل الإرسال) ──
          if (widget.initialConsultation == null)
            Obx(() {
              final hasSent = ctrl.activeMessages.isNotEmpty;
              if (hasSent) return const SizedBox.shrink();
              return Container(
                color: context.colors.surface.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: const ConsultationTypeSelector(),
              );
            }),

          // ── منطقة الـ bubbles ─────────────────────────────
          Expanded(
            child: Obx(() {
              final c = ctrl.activeConsultation.value;
              final msgs = ctrl.activeMessages;

              if (c == null && msgs.isEmpty) return const _EmptyChat();

              return ListView.builder(
                controller: ctrl.scrollController,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                itemCount: msgs.length,
                itemBuilder: (_, i) {
                  final msg = msgs[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: msg.isFromUser
                        ? _UserBubble(message: msg.text)
                        : msg.isPending
                        ? _PendingBubble(isAi: c?.isAi ?? false)
                        : _ReplyBubble(reply: msg.text, isAi: c?.isAi ?? false),
                  );
                },
              );
            }),
          ),

          // ── شريط الإدخال ─────────────────────────────────
          Obx(() => _ChatInputBar(ctrl: ctrl, sending: ctrl.isSending.value)),
        ],
      ),
    );
  }
}

TextStyle _titleStyle(BuildContext context) => TextStyle(
  color: context.colors.textPrimary,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

// ─────────────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────────────

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.colors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colors.accent.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: context.colors.accent,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'ask_question_below'.tr,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'choose_type_hint'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String message;
  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.colors.accent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: Text(
          message,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: context.colors.textOnPrimary,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _ReplyBubble extends StatelessWidget {
  final String reply;
  final bool isAi;
  const _ReplyBubble({required this.reply, required this.isAi});

  @override
  Widget build(BuildContext context) {
    final accent = _typeAccent(context, isAi);
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.only(right: 8, bottom: 2),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: accent.withValues(alpha: 0.5)),
            ),
            child: Icon(
              isAi ? Icons.smart_toy_outlined : Icons.engineering_outlined,
              color: accent,
              size: 18,
            ),
          ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                border: Border.all(color: accent.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAi ? 'ai_assistant'.tr : 'technician'.tr,
                    style: TextStyle(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    reply,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingBubble extends StatelessWidget {
  final bool isAi;
  const _PendingBubble({required this.isAi});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.only(right: 8, bottom: 2),
            decoration: BoxDecoration(
              color: context.colors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: context.colors.warning.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(
              isAi ? Icons.smart_toy_outlined : Icons.engineering_outlined,
              color: context.colors.warning,
              size: 18,
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                border: Border.all(
                  color: context.colors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: isAi
                  // AI → نقاط متحركة
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _Dot(delay: 0),
                        SizedBox(width: 4),
                        _Dot(delay: 200),
                        SizedBox(width: 4),
                        _Dot(delay: 400),
                      ],
                    )
                  // تقني → رسالة انتظار
                  : Text(
                      'awaiting_technician_reply'.tr,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _aCtrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _aCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = Tween<double>(
      begin: 0.3,
      end: 1,
    ).animate(CurvedAnimation(parent: _aCtrl, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _aCtrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _aCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: context.colors.accent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Input bar
// ─────────────────────────────────────────────────────────────────

class _ChatInputBar extends StatelessWidget {
  final ConsultationController ctrl;
  final bool sending;
  const _ChatInputBar({required this.ctrl, required this.sending});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final keyboardHeight = mq.viewInsets.bottom;
    final systemNavBar = mq.padding.bottom;
    return Container(
      color: context.colors.surface,
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: keyboardHeight > 0 ? 10 : systemNavBar + 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 110),
              decoration: BoxDecoration(
                color: context.colors.background,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: context.colors.accent.withValues(alpha: 0.4),
                ),
              ),
              child: TextField(
                controller: ctrl.messageController,
                maxLines: null,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'write_message_hint'.tr,
                  hintStyle: TextStyle(
                    color: context.colors.textSecondary.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: sending ? null : ctrl.submitConsultation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: sending
                    ? context.colors.accent.withValues(alpha: 0.4)
                    : context.colors.accent,
                shape: BoxShape.circle,
              ),
              child: sending
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.textOnPrimary,
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: context.colors.textOnPrimary,
                      size: 22,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
