part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {}

class RegisterFailureMessage extends RegisterState {
  final String errorMessage;

  const RegisterFailureMessage({@required this.errorMessage})
      : assert(errorMessage != null);

  @override
  List<Object> get props => [errorMessage];
}

class RegisterImagesUploading extends RegisterState {}

class RegisterImagesSuccess extends RegisterState {}
