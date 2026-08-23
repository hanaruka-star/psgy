enum MockSenderRole { user, coach }

class MockMessage {
  final String id;
  final MockSenderRole senderRole;
  final String text;
  final String sentAtLabel;

  const MockMessage({
    required this.id,
    required this.senderRole,
    required this.text,
    required this.sentAtLabel,
  });

  bool get isFromCoach => senderRole == MockSenderRole.coach;
}
