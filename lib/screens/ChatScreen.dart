import 'package:flutter/material.dart';
import 'package:tweety_mobile/models/messages.dart';

class ChatScreen extends StatefulWidget {
  final MessageUser user;

  ChatScreen({Key key, this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color:
            isMe ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
        borderRadius: BorderRadius.circular((15.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 5.0),
          Text(
            message.text,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );

    if (isMe) {
      return msg;
    }

    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      height: MediaQuery.of(context).size.height * 0.09,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).canvasColor,
                  offset: Offset(0, 10),
                  blurRadius: (10.0),
                )
              ],
              color: Theme.of(context).cardColor,
            ),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.cursorColor,
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                  filled: true,
                  focusColor: Colors.white,
                  border: InputBorder.none,
                  hintText: 'Send a message...'),
            ),
          )),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          )
        ],
      ),
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: <Widget>[
      //     Container(
      //       width: 340.0,
      //       height: 40.0,
      //       padding: EdgeInsets.symmetric(horizontal: 15.0),
      //       alignment: Alignment.center,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.all(
      //           Radius.circular(20.0),
      //         ),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Theme.of(context).canvasColor,
      //             offset: Offset(0, 10),
      //             blurRadius: (10.0),
      //           )
      //         ],
      //         color: Theme.of(context).cardColor,
      //       ),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: <Widget>[
      //           TextField(
      //             textCapitalization: TextCapitalization.sentences,
      //             onChanged: (value) {},
      //             decoration: InputDecoration.collapsed(
      //               hintText: 'Send a message ...',
      //               hintStyle: Theme.of(context).textTheme.bodyText1,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Theme.of(context).textSelectionTheme.cursorColor,
        ),
        title: Text(
          widget.user.name,
          style: Theme.of(context).appBarTheme.textTheme.caption,
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0)),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0)),
                    child: ListView.builder(
                      reverse: true,
                      padding:
                          EdgeInsets.only(top: 15.0, left: 4.0, right: 4.0),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Message message = messages[index];
                        final bool isMe = message.sender.id == currentUser.id;
                        return _buildMessage(message, isMe);
                      },
                    )),
              ),
            ),
            _buildMessageComposer()
          ],
        ),
      ),
    );
  }
}
