part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}
class LoadingRegister extends RegisterState {}
class SuccessRegister extends RegisterState {}
class ErrorRegister extends RegisterState {
  final String error;
  ErrorRegister(this.error);
}
