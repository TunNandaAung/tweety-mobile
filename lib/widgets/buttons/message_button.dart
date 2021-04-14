import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/chat_room/chat_room_bloc.dart';
import 'package:tweety_mobile/blocs/message/message_bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/repositories/chat_repository.dart';
import 'package:tweety_mobile/screens/chat_screen.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';

class MessageButton extends StatelessWidget {
  final User messageTo;

  const MessageButton({Key key, @required this.messageTo})
      : assert(messageTo != null);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatRoomBloc>(
      create: (context) => ChatRoomBloc(chatRepository: ChatRepository()),
      child: MessageButtonBuilder(
        messageTo: messageTo,
      ),
    );
  }
}

class MessageButtonBuilder extends StatefulWidget {
  final User messageTo;

  const MessageButtonBuilder({Key key, @required this.messageTo})
      : assert(messageTo != null);
  @override
  _MessageButtonBuilderState createState() => _MessageButtonBuilderState();
}

class _MessageButtonBuilderState extends State<MessageButtonBuilder> {
  bool isLoading = false;

  ChatRepository chatRepository = ChatRepository();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatRoomBloc, ChatRoomState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ChatRoomStatus.failure) {
            setState(() {
              isLoading = false;
            });
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
                      Text("Oops! Something went wrong"),
                    ],
                  ),
                ),
              );
          } else if (state.status == ChatRoomStatus.success) {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider<MessageBloc>(
                  create: (context) => MessageBloc(
                    chatRepository: ChatRepository(),
                  ),
                  child: ChatScreen(
                    chatUser: widget.messageTo,
                    chatId: state.chat.id,
                  ),
                ),
              ),
            );
          } else if (state.status == ChatRoomStatus.loading) {
            setState(() {
              isLoading = true;
            });
          }
        },
        builder: (context, state) {
          return Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                  style: BorderStyle.solid),
              shape: BoxShape.circle,
            ),
            child: RawMaterialButton(
                shape: CircleBorder(),
                child: isLoading
                    ? LoadingIndicator(
                        size: 18.0,
                      )
                    : Icon(
                        Icons.messenger_rounded,
                        size: 18.0,
                        color: Theme.of(context).primaryColor,
                      ),
                onPressed: isLoading
                    ? null
                    : () => context.read<ChatRoomBloc>().add(
                          FetchChatRoom(
                            username: widget.messageTo.username,
                          ),
                        )),
          );
        });
  }
}
