import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatefulWidget {
  final VoidCallback? onTap;
  final String title;
  final String actionText;
  final ImageProvider imageProvider;

  const PhotoViewScreen({
    Key? key,
    this.onTap,
    this.title = '',
    this.actionText = '',
    required this.imageProvider,
  }) : super(key: key);

  @override
  PhotoViewScreenState createState() => PhotoViewScreenState();
}

class PhotoViewScreenState extends State<PhotoViewScreen> {
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
            color: Theme.of(context).textSelectionTheme.cursorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Theme.of(context).textSelectionTheme.cursorColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
      body: PhotoView(
        imageProvider: widget.imageProvider,
      ),
    );
  }
}
