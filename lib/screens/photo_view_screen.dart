import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatefulWidget {
  final VoidCallback onTap;
  final String title;
  final String actionText;
  final ImageProvider imageProvider;

  PhotoViewScreen(
      {Key key,
      this.onTap,
      this.title = '',
      this.actionText = '',
      this.imageProvider})
      : super(key: key);

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 25.0,
            letterSpacing: 1.0,
            color: Theme.of(context).textSelectionTheme.cursorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Theme.of(context).textSelectionTheme.cursorColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: widget.onTap,
            child: Text(
              widget.actionText,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).textSelectionTheme.cursorColor,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: PhotoView(
          imageProvider: widget.imageProvider,
        ),
      ),
    );
  }
}
