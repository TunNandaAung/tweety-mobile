import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';
import 'package:tweety_mobile/utils/validators.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  bool isButtonEnabled(AuthProfileState state) {
    return !(state is ResetPasswordRequestLoading);
  }

  String _email;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Theme.of(context).textSelectionTheme.cursorColor,
        ),
        leading: BackButton(),
        title: Text(
          'Tweety',
          style: Theme.of(context).appBarTheme.textTheme.caption,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocListener<AuthProfileBloc, AuthProfileState>(
            listener: (context, state) {
          if (state is AuthProfileErrorMessage) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    elevation: 6.0,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.errorMessage,
                        ),
                        Icon(Icons.error)
                      ],
                    ),
                    backgroundColor: Colors.red),
              );
          }
          if (state is ResetPasswordRequestSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  elevation: 6.0,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: Colors.blue,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Password reset info successfully sent!'),
                    ],
                  ),
                ),
              );
            _formKey.currentState.reset();
            setState(() {
              _autovalidate = false;
            });
          }
        }, child: BlocBuilder<AuthProfileBloc, AuthProfileState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                  left: size.width * .08,
                  top: size.height * .02,
                  right: size.width * .08),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Enter your email adress',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      style: TextStyle(
                          color:
                              Theme.of(context).textSelectionTheme.cursorColor,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        filled: true,
                        focusColor: Theme.of(context).primaryColor,
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.red,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        hintText: 'you@example.com',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      validator: (val) {
                        return !Validators.isValidEmail(val)
                            ? 'Invalid email.'
                            : null;
                      },
                      onSaved: (value) => _email = value,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                        "We'll send an email to this address with password reset instructions."),
                    SizedBox(height: 30.0),
                    InkWell(
                      onTap: isButtonEnabled(state) ? _onFormSubmitted : null,
                      child: Container(
                          width: size.width,
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              (state is ResetPasswordRequestLoading)
                                  ? LoadingIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Send password reset info',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            );
          },
        )),
      ),
    );
  }

  void _onFormSubmitted() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      context.read<AuthProfileBloc>().add(
            RequestPasswordResetInfo(email: _email),
          );
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }
}
