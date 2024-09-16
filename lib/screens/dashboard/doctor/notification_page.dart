import 'package:dio/dio.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import '../../../widgets/model/notification_model.dart';

class DoctorNotificationPage extends StatefulWidget {
  final String doctorId;

  DoctorNotificationPage({required this.doctorId});

  @override
  _DoctorNotificationPageState createState() => _DoctorNotificationPageState();
}

class _DoctorNotificationPageState extends State<DoctorNotificationPage> {
  final Dio _dio = Dio();
  late Future<List<NotificationModel>> _notifications;
  Constants str = Constants();

  @override
  void initState() {
    super.initState();
    _notifications = _fetchNotifications();
  }

  Future<List<NotificationModel>> _fetchNotifications() async {
    final response = await _dio.get(
      'https://66d18e2962816af9a4f411ef.mockapi.io/notifications',
      queryParameters: {
        'doctor_id': widget.doctorId,
      },
    );
    print('doctor id: ${widget.doctorId}');
    print('response: ${response.data}');
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception(str.failedToLoadNotification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(str.noNotificationAvailable));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data![index];
                return NotificationCard(notification: notification);
              },
            );
          }
        },
      ),
    );
  }
}
