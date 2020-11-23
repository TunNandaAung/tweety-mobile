import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/chat/chat_bloc.dart';
import 'package:tweety_mobile/blocs/message/message_bloc.dart';
import 'package:tweety_mobile/models/chat.dart';
import 'package:tweety_mobile/models/message.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tweety_mobile/repositories/chat_repository.dart';
import 'package:tweety_mobile/screens/chat_screen.dart';
import 'package:tweety_mobile/utils/helpers.dart';
import 'package:tweety_mobile/widgets/buttons/avatar_button.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';

class MessagesScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  MessagesScreen({Key key, @required this.scaffoldKey}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
          FetchChatList(),
        );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) context.read<ChatBloc>().add(FetchChatList());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) return false;
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Theme.of(context).textSelectionTheme.cursorColor,
          ),
          leading: AvatarButton(
            scaffoldKey: widget.scaffoldKey,
          ),
          title: Text(
            'Messages',
            style: Theme.of(context).appBarTheme.textTheme.caption,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              child: Expanded(
                child: Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: BlocConsumer<ChatBloc, ChatState>(
                      listener: (context, state) {
                        if (!state.hasReachedMax && _isBottom) {
                          context.read<ChatBloc>().add(FetchChatList());
                        }
                      },
                      builder: (context, state) {
                        switch (state.status) {
                          case ChatStatus.failure:
                            return Refresh(
                              title: 'Couldn\'t load messages',
                              onPressed: () {
                                context.read<ChatBloc>().add(
                                      FetchChatList(),
                                    );
                              },
                            );
                          case ChatStatus.success:
                            if (state.chatList.isEmpty) {
                              return Center(
                                  child: Text(
                                "You have no message yet!",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.bold),
                              ));
                            }
                            return ListView.builder(
                              itemCount: state.hasReachedMax
                                  ? state.chatList.length
                                  : state.chatList.length + 1,
                              controller: _scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                return index >= state.chatList.length
                                    ? LoadingIndicator()
                                    : _chatListItem(state.chatList[index]);
                              },
                            );
                          default:
                            return const Center(child: LoadingIndicator());
                        }
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _chatListItem(Chat chat) {
    final Message message = chat.messages.length > 0
        ? chat.messages.first
        : new Message(
            chatId: chat.id,
            message: "Send a message.",
            readAt: DateTime.now(),
          );
    final messageTo =
        chat.participants.where((user) => user.id != authId()).first;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider<MessageBloc>(
              create: (context) => MessageBloc(
                chatRepository: ChatRepository(),
              ),
              child: ChatScreen(
                chatUser: messageTo,
                chatId: chat.id,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: message.readAt == null && !isCurrentUser(message.sender.id)
              ? Theme.of(context).primaryColor.withOpacity(0.3)
              : Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  backgroundImage: NetworkImage(messageTo.avatar),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      messageTo.name,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        isCurrentUser(message.sender?.id)
                            ? 'You: ' + message.message
                            : '' + message.message,
                        style: Theme.of(context).textTheme.bodyText2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ],
            ),
            chat.messages.length > 0
                ? Column(
                    children: <Widget>[
                      Text(
                        timeago.format(message.createdAt),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                    ],
                  )
                : SizedBox(height: 0.0)
          ],
        ),
      ),
    );
  }
}
