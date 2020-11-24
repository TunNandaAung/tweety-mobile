import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:intl/intl.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:tweety_mobile/blocs/message/message_bloc.dart';
import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/message.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/utils/helpers.dart';
import 'package:tweety_mobile/widgets/expanded_section.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';

class ChatScreen extends StatefulWidget {
  final User chatUser;
  final String chatId;

  ChatScreen({Key key, this.chatUser, this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  bool isPopulated = false;
  bool isTyping = false;
  Timer typingTimer;

  bool isButtonEnabled() {
    return isPopulated;
  }

  MessageBloc _messageBloc;
  FlutterPusher pusherClient;
  Echo echo;

  @override
  void initState() {
    super.initState();
    _messageBloc = context.read<MessageBloc>();

    _messageController.addListener(_onMessageChanged);

    _messageBloc.add(FetchMessages(chatId: widget.chatId));
    _messageBloc.add(
        MarkAsRead(chatId: widget.chatId, username: widget.chatUser.username));

    _scrollController.addListener(_onScroll);

    _setUpEcho();
  }

  void _onScroll() {
    if (_isBottom) _messageBloc.add(FetchMessages(chatId: widget.chatId));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _setUpEcho() {
    final token = Prefer.prefs.getString('token');

    pusherClient = getPusherClient(token);

    echo = echoSetup(token, pusherClient);

    pusherClient.connect(onConnectionStateChange: onConnectionStateChange);

    echo.join("chat." + widget.chatId)
      ..here((users) => print('users'))
      ..listerForWhisper("typing", (event) {
        // log(User.fromJson((event)['user']).username);
        // typingTimer.cancel();

        updateActivePeer(true);

        typingTimer =
            Timer(Duration(milliseconds: 3000), () => updateActivePeer(false));
      })
      ..listen("MessageSent", (event) {
        _messageBloc.add(
          ReceiveMessage(
            chatId: widget.chatId,
            message: Message.fromJson((event)['message']),
          ),
        );
      })
      ..listen("MessageRead", (event) {
        _messageBloc.add(UpdateReadAt());
      });
  }

  void updateActivePeer(isTyping) {
    setState(() {
      this.isTyping = isTyping;
    });
  }

  // void sendTypingEvent(){
  //    echo.join("chat." + widget.chatId).wh;
  // }

  void onConnectionStateChange(ConnectionStateChange event) {
    print("STATE:" + event.currentState);
    if (event.currentState == 'CONNECTED') {
      print('connected');
    } else if (event.currentState == 'DISCONNECTED') {
      print('disconnected');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    if (_messageController.text.trim().length > 0) {
      setState(() {
        isPopulated = true;
      });
    } else {
      setState(() {
        isPopulated = false;
      });
    }
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
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
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
            disabledColor: Colors.grey,
            onPressed: isPopulated ? this._onFormSubmitted : null,
          )
        ],
      ),
    );
  }

  void _onFormSubmitted() {
    _messageBloc.add(
        SendMessage(chatId: widget.chatId, message: _messageController.text));
    _messageController.text = "";
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
        title: Column(
          children: [
            Text(
              widget.chatUser.name,
              style: Theme.of(context).appBarTheme.textTheme.caption,
            ),
            Text(
              "@${widget.chatUser.username}",
              style: Theme.of(context).textTheme.bodyText2,
            )
          ],
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
                    child: BlocBuilder<MessageBloc, MessageState>(
                      builder: (context, state) {
                        if (state is MessageError) {
                          return Refresh(
                            title: 'Couldn\'t load messages',
                            onPressed: () {
                              _messageBloc.add(
                                FetchMessages(chatId: widget.chatId),
                              );
                            },
                          );
                        }
                        if (state is MessageLoaded) {
                          return state.messages.length > 0
                              ? ListView.builder(
                                  reverse: true,
                                  padding: EdgeInsets.only(
                                      top: 15.0, left: 4.0, right: 4.0),
                                  itemCount: state.hasReachedMax
                                      ? state.messages.length
                                      : state.messages.length + 1,
                                  controller: _scrollController,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return index >= state.messages.length
                                        ? LoadingIndicator()
                                        : MessageCard(
                                            message: state.messages[index]);
                                  },
                                )
                              : _messageEmptyText();
                        }
                        return const Center(child: LoadingIndicator());
                      },
                    )),
              ),
            ),
            isTyping
                ? Text(widget.chatUser.name + " is typing...")
                : const SizedBox(
                    height: 0.0,
                  ),
            _buildMessageComposer()
          ],
        ),
      ),
    );
  }

  Widget _messageEmptyText() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 30.0,
          backgroundColor: Theme.of(context).cardColor,
          backgroundImage: NetworkImage(widget.chatUser.avatar),
        ),
        SizedBox(height: 20.0),
        Text(
          "${widget.chatUser.name}\n @${widget.chatUser.username}",
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.0),
        Text(
          "Send a message to ${widget.chatUser.name}.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    ));
  }
}

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({Key key, @required this.message}) : super(key: key);
  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool _showInfo = false;

  void _toggleInfo() {
    setState(() {
      _showInfo = !_showInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = isCurrentUser(widget.message.sender.id);

    final Column msg = Column(children: <Widget>[
      InkWell(
        onTap: _toggleInfo,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          margin: isMe
              ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
              : EdgeInsets.only(top: 8.0, bottom: 8.0),
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor,
            borderRadius: BorderRadius.circular((15.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0),
              Text(
                widget.message.message,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
      ExpandedSection(
        expand: _showInfo,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEE, d MMM hh:mm a').format(
                      widget.message.createdAt.toLocal(),
                    ),
                    textAlign: TextAlign.end,
                  ),
                  widget.message.readAt != null && isMe
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0),
                          child: Icon(
                            Icons.check_circle,
                            size: 15.0,
                            color: Theme.of(context).hintColor,
                          ),
                        )
                      : const SizedBox(height: 0.0)
                ],
              ),
            ),
          ],
        ),
      )
    ]);

    if (isMe) {
      return msg;
    }

    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }
}
