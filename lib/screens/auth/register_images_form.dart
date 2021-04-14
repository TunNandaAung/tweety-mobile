import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tweety_mobile/blocs/auth/authentication/authentication_bloc.dart';
import 'package:tweety_mobile/blocs/auth/register/register_bloc.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';

class RegisterImagesForm extends StatefulWidget {
  RegisterImagesForm({Key key}) : super(key: key);

  @override
  _RegisterImagesFormState createState() => _RegisterImagesFormState();
}

class _RegisterImagesFormState extends State<RegisterImagesForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isButtonEnabled(RegisterState state) {
    return _avatar != null &&
        _banner != null &&
        state is! RegisterImagesUploading;
  }

  bool _autovalidate = false;
  File _avatar;
  File _banner;

  Future _getImage(ImageSource source, bool isAvatar) async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: source);

    File image = File(pickedFile.path);

    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.png,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Edit Photo',
          toolbarColor: Theme.of(context).cardColor,
          activeControlsWidgetColor: Colors.blue,
        ),
      );

      setState(() {
        isAvatar ? _avatar = croppedImage : _banner = croppedImage;
      });
    } else {
      setState(() {});
    }
  }

  Future<bool> selectImageDialog(context, {bool isAvatar = true}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: 230.0,
            width: 200.0,
            padding: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    'Choose an option',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontSize: 20.0),
                  ),
                ),
                SizedBox(height: 30.0),
                InkWell(
                  onTap: () {
                    _getImage(ImageSource.camera, isAvatar);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40.0,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera),
                        SizedBox(width: 20.0),
                        Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                InkWell(
                  onTap: () {
                    _getImage(ImageSource.gallery, isAvatar);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40.0,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.image),
                        SizedBox(width: 20.0),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        context.read<AuthenticationBloc>().add(AuthenticationLoggedIn());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          leading: Container(),
          iconTheme: IconThemeData(
            color: Theme.of(context).appBarTheme.iconTheme.color,
          ),
          title: Text(
            'Upload Avatar & Banner',
            style: Theme.of(context).appBarTheme.textTheme.caption,
          ),
          centerTitle: true,
          actions: <Widget>[
            BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextButton(
                    onPressed: state is! RegisterImagesUploading
                        ? _onSkipPressed
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      onSurface: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterError) {
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
                          "Couldn't upload images.",
                        ),
                      ],
                    ),
                  ),
                );
            }

            if (state is RegisterImagesSuccess) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              context.read<AuthenticationBloc>().add(AuthenticationLoggedIn());
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(12.0),
                child: ListView(
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
                            'Profile Avatar',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(width: 20.0),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap: () =>
                                    selectImageDialog(context, isAvatar: true),
                                child: _avatar != null
                                    ? CircleAvatar(
                                        radius: 50.0,
                                        backgroundColor:
                                            Theme.of(context).cardColor,
                                        backgroundImage: FileImage(_avatar),
                                      )
                                    : Container(
                                        width: 120.0,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).cardColor,
                                        ),
                                        child: Icon(
                                          Icons.add_photo_alternate,
                                          size: 30.0,
                                          color: Colors.grey,
                                        )),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Profile Banner',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () =>
                                selectImageDialog(context, isAvatar: false),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: _banner != null
                                  ? Image(
                                      image: FileImage(_banner),
                                      width: 400.0,
                                    )
                                  : Container(
                                      width: 400.0,
                                      height: 120.0,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                      ),
                                      child: Icon(
                                        Icons.add_photo_alternate,
                                        size: 30.0,
                                        color: Colors.grey,
                                      )),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Material(
                              color: Theme.of(context).primaryColor,
                              child: InkWell(
                                onTap: isButtonEnabled(state)
                                    ? _onFormSubmitted
                                    : null,
                                child: SizedBox(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: (state is RegisterImagesUploading)
                                      ? LoadingIndicator(
                                          color: Colors.white,
                                        )
                                      : Center(
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                letterSpacing: 1.0),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onFormSubmitted() {
    context.read<RegisterBloc>().add(
          UploadRegisterImages(
            avatar: _avatar,
            banner: _banner,
          ),
        );
  }

  void _onSkipPressed() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    context.read<AuthenticationBloc>().add(AuthenticationLoggedIn());
  }
}
