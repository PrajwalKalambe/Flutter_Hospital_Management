import 'package:doctor_management/widgets/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.tealAccent,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/icons/boy_face.png'),
                  radius: 24, // Adjust the size of the avatar to match the design
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.user_name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Increase the font size for the username
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(fontSize: 16),
                        maxLines: null, // Allows unlimited lines for the message
                        overflow: TextOverflow.visible, // Text will not be truncated
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                DateFormat('h:mm a').format(notification.createdAt),
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
