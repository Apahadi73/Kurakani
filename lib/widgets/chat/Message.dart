import 'package:flutter/material.dart';

// builds individual message
class Message extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String userName;
  final String avatarUrl;
  Message({
    @required this.message,
    @required this.isMe,
    @required this.key,
    @required this.userName,
    @required this.avatarUrl,
  });

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(avatarUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) _buildAvatar(context),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
            decoration: BoxDecoration(
              color: isMe ? Color(0xff808000) : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(8),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(8),
              ),
            ),
            width: size.width / 2,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Text(
                //   userName,
                //   style: TextStyle(
                //     color: Theme.of(context).primaryTextTheme.bodyText1.color,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Text(
                  message,
                  style: TextStyle(color: Theme.of(context).primaryTextTheme.bodyText1.color),
                ),
              ],
            ),
          ),
          if (isMe) _buildAvatar(context),
        ],
      ),
    );
  }
}
