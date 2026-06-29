/// رسالة واحدة داخل المحادثة — تُخزَّن محلياً وتُحمَّل عند العودة
class ChatMessage {
  final String text;
  final bool isFromUser; // true = المستخدم | false = AI أو تقني
  final DateTime time;
  final bool isPending; // bubble انتظار — لا تُحفظ

  const ChatMessage({
    required this.text,
    required this.isFromUser,
    required this.time,
    this.isPending = false,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'isFromUser': isFromUser,
    'time': time.millisecondsSinceEpoch,
    // isPending لا تُحفظ — لأن الرسائل المعلقة تُعاد بناؤها من الـ API
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    text: json['text'] as String? ?? '',
    isFromUser: json['isFromUser'] as bool? ?? true,
    time: DateTime.fromMillisecondsSinceEpoch(json['time'] as int? ?? 0),
  );
}
