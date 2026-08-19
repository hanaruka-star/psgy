import 'package:firebase_auth/firebase_auth.dart';
import 'package:psgy/core/error/app_exception.dart';
import 'package:psgy/core/error/exception_reporter.dart';

AppException mapFirebaseException(dynamic e, [StackTrace? stackTrace]) {
  if (e is AppException) {
    reportAppException(e, stackTrace);
    return e;
  }

  if (e is FirebaseAuthException) {
    final exception = AuthException(
      _authMessage(e),
      code: e.code,
    );
    reportAppException(exception, stackTrace);
    return exception;
  }

  if (e is FirebaseException) {
    if (e.code == 'unavailable') {
      final exception = NetworkException(
        e.message ?? 'Không thể kết nối mạng. Vui lòng thử lại.',
        code: e.code,
      );
      reportAppException(exception, stackTrace);
      return exception;
    }

    if (e.code == 'permission-denied') {
      final exception = PermissionException(
        'Bạn chưa có quyền xem dữ liệu này. '
        'Nếu bạn là nhân viên, hãy đăng nhập lại hoặc liên hệ quản lý bãi.',
        code: e.code,
      );
      reportAppException(exception, stackTrace);
      return exception;
    }

    if (e.code == 'resource-exhausted') {
      final exception = NetworkException(
        'Hệ thống đang bận. Vui lòng thử lại sau vài giây.',
        code: e.code,
      );
      reportAppException(exception, stackTrace);
      return exception;
    }

    if (e.code == 'deadline-exceeded') {
      final exception = NetworkException(
        'Kết nối quá chậm. Kiểm tra mạng và thử lại.',
        code: e.code,
      );
      reportAppException(exception, stackTrace);
      return exception;
    }

    final exception = UnknownException(
      e.message ?? e.code,
      code: e.code,
    );
    reportAppException(exception, stackTrace);
    return exception;
  }

  final message = _cleanMessage(e);
  if (_isSlotUnavailable(message)) {
    final exception = SlotUnavailableException(message);
    reportAppException(exception, stackTrace);
    return exception;
  }

  final exception = UnknownException(message.isEmpty ? 'Đã có lỗi xảy ra.' : message);
  reportAppException(exception, stackTrace);
  return exception;
}

String _authMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return 'Email hoặc mật khẩu không đúng.';
    case 'invalid-email':
      return 'Email không hợp lệ.';
    case 'user-disabled':
      return 'Tài khoản này đã bị vô hiệu hóa. Liên hệ quản trị viên bãi xe.';
    case 'too-many-requests':
      return 'Quá nhiều lần đăng nhập. Vui lòng thử lại sau vài phút.';
    case 'user-token-expired':
    case 'id-token-expired':
      return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
    case 'network-request-failed':
      return 'Không thể kết nối. Kiểm tra mạng và thử lại.';
    default:
      return 'Đăng nhập thất bại. Vui lòng kiểm tra thông tin và thử lại.';
  }
}

String _cleanMessage(dynamic e) {
  return e.toString().replaceFirst('Exception: ', '').trim();
}

bool _isSlotUnavailable(String message) {
  final normalized = message.toLowerCase();
  return normalized.contains('không còn slot') ||
      normalized.contains('khong con slot') ||
      normalized.contains('no available slots') ||
      normalized.contains('hết chỗ') ||
      normalized.contains('het cho');
}
