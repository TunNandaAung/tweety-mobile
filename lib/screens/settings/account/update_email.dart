import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/utils/validators.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';

class UpdateEmailScreen extends StatefulWidget {
  final User user;

  UpdateEmailScreen({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  _UpdateEmailScreenState createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  String _email;
  String _password;

  bool isButtonEnabled(AuthProfileState state) {
    return !(state is AuthProfileEmailUpdating);
  }

  bool _isPasswordHidden = true;
  void _toggleVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: BackButton(
            color: Theme.of(context).appBarTheme.iconTheme.color,
          ),
          title: Text(
            'Update Email',
            style: Theme.of(context).appBarTheme.textTheme.caption,
          ),
          centerTitle: true,
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
        ),
        body: BlocListener<AuthProfileBloc, AuthProfileState>(
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
                    backgroundColor: Colors.red,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.errorMessage,
                        ),
                      ],
                    ),
                  ),
                );
            }

            if (state is AuthProfileInfoUpdateSuccess) {
              context
                  .read<AuthProfileBloc>()
                  .add(ReloadAuthProfile(user: state.user));
              Navigator.of(context).pop();
            }
          },
          child: BlocBuilder<AuthProfileBloc, AuthProfileState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: size.height,
                        child: Stack(
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              autovalidateMode: _autovalidate
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Current',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    widget.user.email,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    'Re-enter your password to verify',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .cursorColor,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                        filled: true,
                                        focusColor:
                                            Theme.of(context).primaryColor,
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2.0,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            width: 2.0,
                                            color: Colors.red,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: Colors.grey,
                                        ),
                                        suffixIcon: IconButton(
                                            color: Colors.grey,
                                            icon: _isPasswordHidden
                                                ? Icon(Icons.visibility_off)
                                                : Icon(Icons.visibility),
                                            onPressed: () {
                                              _toggleVisibility();
                                            }),
                                        hintText: 'Password'),
                                    obscureText: _isPasswordHidden,
                                    validator: (val) {
                                      return val.trim().isEmpty
                                          ? 'Password cannot be empty.'
                                          : null;
                                    },
                                    onSaved: (value) => _password = value,
                                  ),
                                  SizedBox(height: 30.0),
                                  Text(
                                    'Enter your new email address',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .cursorColor,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                        filled: true,
                                        focusColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            width: 2.0,
                                            color: Colors.red,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.mail,
                                          color: Colors.grey,
                                        ),
                                        hintText: 'Email'),
                                    validator: (val) {
                                      return !Validators.isValidEmail(val)
                                          ? 'Invalid email.'
                                          : null;
                                    },
                                    onSaved: (value) => _email = value,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30.0),
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOutQuad,
                              bottom: keyboardOpen ? size.height * 0.55 : 100.0,
                              child: InkWell(
                                onTap: isButtonEnabled(state)
                                    ? _onFormSubmitted
                                    : null,
                                child: Container(
                                  width: size.width * 0.94,
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: (state is AuthProfileEmailUpdating)
                                      ? LoadingIndicator(
                                          color: Colors.white,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Update',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  letterSpacing: 1.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 20.0),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  void _onFormSubmitted() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      context.read<AuthProfileBloc>().add(
            UpdateAuthProfileEmail(password: _password, email: _email),
          );
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }
}
