import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final bool loading;
  final Map<String, String>? data;
  final String? error;

  const UserState({this.loading = false, this.data, this.error});

  factory UserState.initial() => const UserState();
  factory UserState.loading() => const UserState(loading: true);
  factory UserState.success(Map<String, String> user) =>
      UserState(data: user);
  factory UserState.failure(String message) =>
      UserState(error: message);

  @override
  List<Object?> get props => [loading, data, error];
}