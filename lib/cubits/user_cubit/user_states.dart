import 'package:balagh/model/user.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final appUser? user;

  UserLoaded(this.user);
}

class UserError extends UserState {
  final String errorMessage;

  UserError(this.errorMessage);
}
