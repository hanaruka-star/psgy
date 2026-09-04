import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:psgy/features/auth/domain/repositories/auth_repository.dart';
import 'package:psgy/features/auth/domain/usecases/index.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuth.instance);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInUseCase(repository);
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});

final watchAuthStateUseCaseProvider = Provider<WatchAuthStateUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return WatchAuthStateUseCase(repository);
});
