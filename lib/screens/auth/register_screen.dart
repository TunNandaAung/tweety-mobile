import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/auth/register/register_bloc.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';
import 'package:tweety_mobile/screens/auth/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository userRepository;
  const RegisterScreen({this.userRepository, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(userRepository: userRepository),
      child: RegisterForm(),
    );
  }
}
