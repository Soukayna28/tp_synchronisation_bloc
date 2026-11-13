import 'dart:async';
import 'dart:math';

class FakeDatabase {
  final _rng = Random();

  Future<Map<String, String>> fetchUserData() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_rng.nextInt(4) == 0) {
      throw Exception('Serveur indisponible (503). Réessayez.');
    }

    return {'id': '123', 'name': 'John Doe', 'email': 'john.doe@example.com'};
  }

  Stream<String> fetchNotifications() async* {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(seconds: 1));
      if (i == 3 && _rng.nextInt(5) == 0) {
        throw Exception('Erreur de streaming (perte réseau).');
      }
      yield 'Notification $i';
    }
  }
}