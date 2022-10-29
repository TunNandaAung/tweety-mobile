import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile/profile_bloc.dart';
import 'package:tweety_mobile/models/user.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  bool isButtonEnabled(AuthProfileState state) {
    return _formKey.currentState!.validate() &&
        state is! AuthProfileInfoUpdating;
  }

  bool _autovalidate = false;
  File? _avatar;
  File? _banner;

  late String _name;
  late String _username;
  late String _description;

  Future _getImage(ImageSource source, bool isAvatar) async {
    setState(() {});
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      CroppedFile? croppedImage = await _cropper.cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          compressFormat: ImageCompressFormat.png,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Edit Photo',
              toolbarColor: Theme.of(context).cardColor,
              activeControlsWidgetColor: Colors.blue,
            ),
          ]);

      setState(() {
        isAvatar
            ? _avatar = File(croppedImage!.path)
            : _banner = File(croppedImage!.path);
      });
    } else {
      setState(() {});
    }
  }

  selectImageDialog(context, {bool isAvatar = true}) {
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
            padding: const EdgeInsets.all(30.0),
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
                        .caption!
                        .copyWith(fontSize: 20.0),
                  ),
                ),
                const SizedBox(height: 30.0),
                InkWell(
                  onTap: () {
                    _getImage(ImageSource.camera, isAvatar);
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                    height: 40.0,
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.camera),
                        const SizedBox(width: 20.0),
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
                const SizedBox(height: 30.0),
                InkWell(
                  onTap: () {
                    _getImage(ImageSource.gallery, isAvatar);
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                    height: 40.0,
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.image),
                        const SizedBox(width: 20.0),
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Theme.of(context).appBarTheme.iconTheme!.color,
          ),
          title: Text(
            'Edit Profile',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: TextButton(
                // onPressed: isButtonEnabled() ? _onFormSubmitted : null,
                onPressed: _onFormSubmitted,
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.button!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            )
          ],
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
            if (state is AuthProfileInfoUpdating) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    elevation: 6.0,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: Colors.black26,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Saving...',
                        ),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                );
            }
            if (state is AuthProfileInfoUpdateSuccess) {
              context.read<ProfileBloc>().add(RefreshProfile(user: state.user));
              context
                  .read<AuthProfileBloc>()
                  .add(ReloadAuthProfile(user: state.user));

              Navigator.of(context).pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                      const SizedBox(width: 20.0),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: () =>
                                selectImageDialog(context, isAvatar: true),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Theme.of(context).cardColor,
                              backgroundImage: _avatar == null
                                  ? NetworkImage(widget.user.avatar)
                                  : FileImage(_avatar!) as ImageProvider,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Profile Banner',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () =>
                            selectImageDialog(context, isAvatar: false),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                            image: _banner == null
                                ? NetworkImage(widget.user.banner)
                                : FileImage(_banner!) as ImageProvider,
                            width: 400.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Name',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor,
                            fontWeight: FontWeight.w500),
                        initialValue: widget.user.name,
                        decoration: InputDecoration(
                          filled: true,
                          focusColor: Theme.of(context).primaryColor,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.red,
                            ),
                          ),
                          hintText: 'Name',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (val) {
                          return val!.trim().isEmpty
                              ? 'Name cannot be empty'
                              : null;
                        },
                        onSaved: (value) => _name = value!,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'username',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor,
                            fontWeight: FontWeight.w500),
                        initialValue: widget.user.username,
                        decoration: InputDecoration(
                          filled: true,
                          focusColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.red,
                            ),
                          ),
                          hintText: 'username',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (val) {
                          return val!.trim().isEmpty
                              ? 'username cannot be empty'
                              : null;
                        },
                        onSaved: (value) => _username = value!,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        maxLines: 5,
                        style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor,
                            fontWeight: FontWeight.w500),
                        initialValue: widget.user.description,
                        decoration: InputDecoration(
                          filled: true,
                          focusColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.red,
                            ),
                          ),
                          hintText: 'A little info about yourself?',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onSaved: (value) => _description = value!,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _onFormSubmitted() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      context.read<AuthProfileBloc>().add(
            UpdateAuthProfileInfo(
              name: _name,
              username: _username,
              description: _description,
              avatar: _avatar,
              banner: _banner,
            ),
          );
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }
}
