import 'dart:async';

class AuthEventBus {
  AuthEventBus._();

  static final AuthEventBus instance = AuthEventBus._();

  final StreamController<void> _unauthorized =
      StreamController<void>.broadcast();

  Stream<void> get unauthorizedStream => _unauthorized.stream;

  void emitUnauthorized() {
    if (!_unauthorized.isClosed) {
      _unauthorized.add(null);
    }
  }
}
