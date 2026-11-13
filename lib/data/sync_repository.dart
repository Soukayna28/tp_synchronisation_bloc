import 'fake_database.dart';

abstract class SyncRepository {
  Future<Map<String, String>> getUser();
  Stream<String> notifications();
}

class FakeSyncRepository implements SyncRepository {
  final FakeDatabase db;
  FakeSyncRepository(this.db);

  @override
  Future<Map<String, String>> getUser() => db.fetchUserData();

  @override
  Stream<String> notifications() => db.fetchNotifications();
}