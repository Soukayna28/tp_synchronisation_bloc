import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class UserRequested extends UserEvent {
  const UserRequested();
}

class UserRefreshed extends UserEvent {
  const UserRefreshed();
}