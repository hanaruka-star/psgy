class AuthUser {
  const AuthUser({
    required this.uid,
    this.email,
  });

  final String uid;
  final String? email;
}
