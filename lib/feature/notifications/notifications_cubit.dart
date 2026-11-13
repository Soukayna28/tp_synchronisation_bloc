import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/sync_repository.dart';

class NotificationsState extends Equatable {
  final bool listening;
  final List<String> items;
  final String? error;
  final bool completed;

  const NotificationsState({
    this.listening = false,
    this.items = const [],
    this.error,
    this.completed = false,
  });

  NotificationsState copyWith({
    bool? listening,
    List<String>? items,
    String? error,
    bool? completed,
  }) {
    return NotificationsState(
      listening: listening ?? this.listening,
      items: items ?? this.items,
      error: error,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [listening, items, error, completed];
}

class NotificationsCubit extends Cubit<NotificationsState> {
  final SyncRepository repo;
  StreamSubscription<String>? _sub;

  NotificationsCubit(this.repo) : super(const NotificationsState());

  void start() {
    if (state.listening) return;

    emit(state.copyWith(listening: true, items: [], error: null, completed: false));

    _sub = repo.notifications().listen(
      (msg) => emit(state.copyWith(items: List.of(state.items)..add(msg))),
      onError: (e) => emit(state.copyWith(error: e.toString(), listening: false)),
      onDone: () => emit(state.copyWith(listening: false, completed: true)),
      cancelOnError: true,
    );
  }

  Future<void> stop() async {
    await _sub?.cancel();
    emit(state.copyWith(listening: false));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}