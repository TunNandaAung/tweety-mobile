import 'package:flutter/material.dart';

class PublishTweetScreen extends StatefulWidget {
  PublishTweetScreen({Key key}) : super(key: key);

  @override
  _PublishTweetScreenState createState() => _PublishTweetScreenState();
}

class _PublishTweetScreenState extends State<PublishTweetScreen> {
  final TextEditingController _bodyController = TextEditingController();
  double characterLmitValue = 0;
  double limit = 255;

  @override
  void initState() {
    _bodyController.addListener(_onBodyChanged);

    super.initState();
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  void _onBodyChanged() {
    setState(() {
      updateCharacterLimit();
    });
  }

  updateCharacterLimit() {
    if (_bodyController.text.length == 0) {
      characterLmitValue = 0.0;
    }
    if (_bodyController.text.length > limit) {
      characterLmitValue = 1.0;
    }
    characterLmitValue = (_bodyController.text.length * 100) / 25500.0;
  }

  reachWarningLimit() {
    return _bodyController.text.length > (limit - 21);
  }

  reachErrorLimit() {
    return _bodyController.text.length > (limit + 9);
  }

  reachInitailErrorLimit() {
    return _bodyController.text.length > limit &&
        _bodyController.text.length < (limit + 9);
  }

  getIndicatorColor() {
    if (reachInitailErrorLimit()) {
      return Colors.red[400];
    }

    if (reachWarningLimit()) {
      return Colors.orange;
    }

    return Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                  ),
                  Container(
                    width: 320.0,
                    height: null,
                    child: SingleChildScrollView(
                      child: TextFormField(
                        controller: _bodyController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,

                          hintText: "Say something about task ...",
                          // errorStyle: TextStyle(fontFamily: 'Poppins-Medium'),
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(-10, -10),
                      blurRadius: 10.0,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _characterLimitIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _characterLimitIndicator() {
    return _bodyController.text != null && reachErrorLimit()
        ? Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              '${limit.toInt() - _bodyController.text.length}',
              style: TextStyle(
                color: Colors.red[400],
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                child: CircularProgressIndicator(
                  value: characterLmitValue,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    getIndicatorColor(),
                  ),
                ),
              ),
              reachWarningLimit()
                  ? Text(
                      '${limit.toInt() - _bodyController.text.length}',
                      style: TextStyle(
                        color: getIndicatorColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      '',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
            ],
          );
  }
}
