import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tweety_mobile/blocs/message/message_bloc.dart';
import 'package:tweety_mobile/models/message.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/utils/helpers.dart';
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

  bool get isPopulated => _messageController.text.isNotEmpty;

  MessageBloc _messageBloc;

  @override
  void initState() {
    super.initState();
    _messageBloc = context.read<MessageBloc>();

    _messageBloc.add(
      FetchMessages(chatId: widget.chatId),
    );
    _scrollController.addListener(_onScroll);
    _messageController.addListener(_onMessageChanged);
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

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    print(isPopulated);
  }

  _buildMessage(Message message) {
    bool isMe = isCurrentUser(message.sender.id);
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
            timeago.format(message.createdAt, locale: 'en_short'),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 5.0),
          Text(
            message.message,
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
            onPressed: isPopulated ? _onFormSubmitted : null,
          )
        ],
      ),
    );
  }

  void _onFormSubmitted() {
    // _messageBloc.add(
    //     SendMessage(chatId: widget.chatId, message: _messageController.text));
    print("PRESSED");
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
        title: Text(
          widget.chatUser.name,
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
                          return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.only(
                                top: 15.0, left: 4.0, right: 4.0),
                            itemCount: state.hasReachedMax
                                ? state.messages.length
                                : state.messages.length + 1,
                            controller: _scrollController,
                            itemBuilder: (BuildContext context, int index) {
                              return index >= state.messages.length
                                  ? LoadingIndicator()
                                  : _buildMessage(state.messages[index]);
                              // final Message message = messages[index];
                              // final bool isMe =
                              //     message.sender.id == currentUser.id;
                              // return _buildMessage(message, isMe);
                            },
                          );
                        }
                        return const Center(child: LoadingIndicator());
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
