import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/sync_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SyncRepository repo;

  UserBloc(this.repo) : super(UserState.initial()) {
    on<UserRequested>(_onLoad);
    on<UserRefreshed>(_onLoad);
  }

  Future<void> _onLoad(UserEvent event, Emitter<UserState> emit) async {
    emit(UserState.loading());
    try {
      final user = await repo.getUser();
      emit(UserState.success(user));
    } catch (e) {
      emit(UserState.failure(e.toString()));
    }
  }
}