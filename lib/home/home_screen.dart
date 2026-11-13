import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/fake_database.dart';
import '../data/sync_repository.dart';
import '../feature/user/user_bloc.dart';
import '../feature/user/user_event.dart';
import '../feature/user/user_state.dart';
import '../feature/notifications/notifications_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = FakeSyncRepository(FakeDatabase());
    return MultiRepositoryProvider(
      providers: [RepositoryProvider<SyncRepository>.value(value: repo)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => UserBloc(repo)..add(const UserRequested())),
          BlocProvider(create: (ctx) => NotificationsCubit(repo)),
        ],
        child: Scaffold(
          appBar: AppBar(title: const Text('Synchronisation TP')),
          body: const Body(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.read<UserBloc>().add(const UserRefreshed()),
            icon: const Icon(Icons.refresh),
            label: const Text('Rafraichir user'),
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Utilisateur :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state.loading) {
                return const CircularProgressIndicator();
              }
              if (state.error != null) {
                return Text('Erreur : ${state.error}');
              }
              if (state.data != null) {
                return Text(
                  'Nom : ${state.data!['name']}\nEmail : ${state.data!['email']}',
                  style: const TextStyle(fontSize: 16),
                );
              }
              return const Text('Aucune donnée disponible.');
            },
          ),
          const SizedBox(height: 20),
          const Text('Notifications :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => context.read<NotificationsCubit>().start(),
                child: const Text('Démarrer'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.read<NotificationsCubit>().stop(),
                child: const Text('Arrêter'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state.error != null) {
                  return Text('Erreur : ${state.error}');
                }
                if (state.items.isEmpty && !state.listening && !state.completed) {
                  return const Text('Aucune notification.');
                }
                return ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.items[index]),
                      leading: const Icon(Icons.notification_important),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}