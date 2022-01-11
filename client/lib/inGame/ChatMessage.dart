class ChatMessage {
  final String text;
  final bool isSender;
  final String image;

  ChatMessage({
    this.text = '',
    required this.isSender,
    required this.image,
  });
}