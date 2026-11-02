import 'package:cash_money/core/services/session_service.dart';


class FakeSessionService implements SessionService {
  @override
  String currentUid = 'test-uid';

  @override
  bool get isLoggedIn => currentUid.isNotEmpty;

  @override
  Future<void> loadFromStorage() async {}

  @override
  Future<void> login(String uid) async { currentUid = uid; }

  @override
  Future<void> logout() async { currentUid = ''; }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}