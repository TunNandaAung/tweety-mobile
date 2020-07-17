import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tweety_mobile/models/user.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  EditProfileScreen({Key key, @required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  File _avatar;
  File _banner;
  bool _imageInProcess = false;

  String _name;
  String _username;
  String _description;

  Future _getImage(ImageSource source, bool isAvatar) async {
    final picker = ImagePicker();

    setState(() {
      _imageInProcess = true;
    });
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
          toolbarColor: Colors.white,
          activeControlsWidgetColor: Colors.blue,
        ),
      );

      setState(() {
        isAvatar ? _avatar = croppedImage : _banner = croppedImage;
        _imageInProcess = false;
      });
    } else {
      setState(() {
        _imageInProcess = false;
      });
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
                            color: Theme.of(context).cursorColor,
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
                            color: Theme.of(context).cursorColor,
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
          color: Colors.black,
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(letterSpacing: 1.0, color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: FlatButton(
              // onPressed: isButtonEnabled() ? _onFormSubmitted : null,
              onPressed: _onFormSubmitted,
              color: Theme.of(context).primaryColor,
              disabledColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidate: _autovalidate,
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
                        onTap: () => selectImageDialog(context, isAvatar: true),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Theme.of(context).cardColor,
                          backgroundImage: _avatar == null
                              ? NetworkImage(widget.user.avatar)
                              : FileImage(_avatar),
                        ),
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
                    onTap: () => selectImageDialog(context, isAvatar: false),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image(
                        image: _banner == null
                            ? NetworkImage(widget.user.banner)
                            : FileImage(_banner),
                        width: 400.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                      filled: true,
                      focusColor: Colors.white,
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
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    validator: (val) {
                      return val.trim().isEmpty ? 'Name cannot be empty' : null;
                    },
                    onSaved: (value) => _name = value,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Username',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    initialValue: widget.user.username,
                    decoration: InputDecoration(
                      filled: true,
                      focusColor: Colors.white,
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
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    validator: (val) {
                      return val.trim().isEmpty
                          ? 'Username cannot be empty'
                          : null;
                    },
                    onSaved: (value) => _username = value,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    maxLines: 5,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    initialValue: widget.user.description,
                    decoration: InputDecoration(
                      filled: true,
                      focusColor: Colors.white,
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
                      hintText: 'A little info about yourself?',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onSaved: (value) => _description = value,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onFormSubmitted() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("CALLED");
      // BlocProvider.of<ProfileBloc>(context).add(
      //   UpdateProfileInfo(
      //     name: _name,
      //     shopAddress: _address,
      //     phone: _phone,
      //     shopName: _shopName,
      //   ),
      // );
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }
}
