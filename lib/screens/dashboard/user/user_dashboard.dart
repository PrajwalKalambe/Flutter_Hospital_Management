import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/screens/dashboard/user/notification_page.dart';
import 'package:doctor_management/screens/dashboard/user/search_doctor.dart';
import 'package:doctor_management/screens/dashboard/user/setting_page.dart';
import 'package:doctor_management/widgets/navbar.dart';
import 'package:flutter/material.dart';

String? user_name;

String? user_id;
class UserDashboard extends StatefulWidget {
  final String email;
  UserDashboard({required this.email});
  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  
   @override
  void initState() {
    super.initState();
    _fetchUserName(widget.email);
  }

Future<void> _fetchUserName(String email) async {
  
  try {
    // Replace with your actual API call
    final response = await Dio().get(
      'https://66d0a8bc181d059277df52d0.mockapi.io/user',
      queryParameters: {'email': email},
    );
    
    // Check if response data is a String (likely JSON) and decode it
    final responseData = response.data is String ? jsonDecode(response.data) : response.data;
    if (responseData is List && responseData.isNotEmpty) {
      final user = responseData[0]; // Access the first user in the list
      final String firstName = user['first_name'];
      final String lastName = user['last_name'];
      final String fetchedUserId = user['id'];

      setState(() {
        user_name = '$firstName $lastName';
        user_id = fetchedUserId;
      });

      print('User Name: $user_name');
      print('User ID: $user_id');
    } else {
      print('User data is empty or not a list');
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.white,
      appBar: AppBar(
        title: Text('Good Morning'),
        backgroundColor: color.newbgColor,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_active),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserNotificationPage()));
            },
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        
  child: Padding(
    
    padding: EdgeInsets.symmetric(horizontal: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity, 
          
          padding: EdgeInsets.all(10.0), 
          decoration: BoxDecoration(
            color: color.newbgColor, 
             
          ),
          
          child: SearchBar(), 
        ),
        SizedBox(height: 30),
        TopDoctorSection(),
        SizedBox(height: 30),
        ExerciseServiceSection(),
      ],
    ),
  ),
),

      bottomNavigationBar: CustomBottomNavBar(
        items: [
          {
            'icon': Icons.home,
            'isSelected': true,
            'onPressed': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserDashboard(email:widget.email)),
              );
            },
          },
          {
            'icon': Icons.search,
            'onPressed': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchDoctor()),
              );
            },
          },
          {
            'icon': Icons.shopping_cart,
            'onPressed': () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => AppointmentsPage()),
              // );
            },
          },
          {
            'icon': Icons.settings,
            'onPressed': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
          },
        ],
      ),
    );
  }
    
  }


class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Let's search for a Specialist",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 25),
        Container(
          width: double.infinity, // Makes the search bar take the full width of the parent container
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search here....',
              prefixIcon: Icon(Icons.search, color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              // Handle search input
              print('Search query: $value');
            },
          ),
        ),
      ],
    ),
  );
}

}

class TopDoctorSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Doctor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                child: Text('See all',style: TextStyle(fontSize: 17),),
                onPressed: () {
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchDoctor()),
              );
                  print('See all top doctors pressed');
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              // Navigate to SearchDoctor page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchDoctor()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('assets/icons/doctor_image.png'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dr Alexa Sharma', style: TextStyle(fontSize: 17,fontWeight: FontWeight.w900)),
                      Text('Heart Specialist', style: TextStyle(fontSize: 15),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseServiceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Exercise Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ExerciseCard(title: 'Easy', onTap: () => print('Easy exercise tapped')),
              ExerciseCard(title: 'Moderate', onTap: () => print('Moderate exercise tapped')),
              ExerciseCard(title: 'Advance', onTap: () => print('Advance exercise tapped')),
            ],
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  ExerciseCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(title)),
      ),
    );
  }
}