import 'package:dio/dio.dart';
import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/utils/notification_model.dart';
import 'package:flutter/material.dart';
import 'user_dashboard.dart';

class UserNotificationPage extends StatefulWidget {
  @override
  _UserNotificationPageState createState() => _UserNotificationPageState();
}

class _UserNotificationPageState extends State<UserNotificationPage> {
  late Future<List<NotificationModel>> _notifications;
  final Dio _dio = Dio();
  Constants str = Constants();

  @override
  
  void initState() {
    super.initState();
    _notifications = _fetchNotifications(user_id!);
  }

  Future<List<NotificationModel>> _fetchNotifications(String userId) async {
    try {
      final response = await _dio.get(
        'https://66d18e2962816af9a4f411ef.mockapi.io/notifications',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception(str.failedToLoadNotification);
      }
    } catch (e) {
      print(str.errorFetchingNotifications + ' $e');
      throw e;
    }
  }

  Future<String> _fetchDoctorName(String doctorId) async {
    try {
      final response = await _dio.get(
        'https://66d0a8bc181d059277df52d0.mockapi.io/doctor/$doctorId',
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is Map<String, dynamic>) {
          final String firstName = responseData['first_name'];
          final String lastName = responseData['last_name'];
          return 'Dr. $firstName $lastName';
        } else {
          throw Exception(str.unexpectedResponse);
        }
      } else {
        throw Exception(str.failedToLoadDoctorNotification);
      }
    } catch (e) {
      print(str.errorInFetchingDoctor + ' $e');
      return str.doctorInfoNotAvailable;
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
            return Center(child: Text('No notifications available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data![index];
                return FutureBuilder<String>(
                  future: _fetchDoctorName(notification.doctorId),
                  builder: (context, doctorSnapshot) {
                    if (doctorSnapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text('Loading...'),
                      );
                    } else if (doctorSnapshot.hasError) {
                      return ListTile(
                        title: Text(str.errorLoadingDoctor),
                      );
                    } else {
                      final doctorName = doctorSnapshot.data ?? 'Doctor';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        child: Card(
                          color: color.newbgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctorName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  notification.message,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '5 min ago',  // Example timestamp
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
