import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _autovalidate = false;
  File _avatar;
  File _banner;
  bool _imageInProcess = false;

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
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView(
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
                        ? AssetImage('assets/images/twitter_flutter_bg.png')
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
                      ? AssetImage('assets/images/twitter_flutter_bg.png')
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
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
                    width: 3.0,
                    color: Colors.red,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 3.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                hintText: 'Name',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              autovalidate: true,
              autocorrect: false,
              // validator: (_) {
              //   if (!state.isEmailValid) {
              //     return ('Invalid Email');
              //   }
              //   return null;
              // },
            ),
            SizedBox(height: 20.0),
            Text(
              'Username',
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
                    width: 3.0,
                    color: Colors.red,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 3.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                hintText: 'Username',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              autovalidate: true,
              autocorrect: false,
              // validator: (_) {
              //   if (!state.isEmailValid) {
              //     return ('Invalid Email');
              //   }
              //   return null;
              // },
            ),
            SizedBox(height: 20.0),
            Text(
              'Description',
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              maxLines: 5,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
                    width: 3.0,
                    color: Colors.red,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 3.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                hintText: 'A little info about yourself?',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              autovalidate: true,
              autocorrect: false,
              // validator: (_) {
              //   if (!state.isEmailValid) {
              //     return ('Invalid Email');
              //   }
              //   return null;
              // },
            ),
          ],
        ),
      ),
    );
  }
}
