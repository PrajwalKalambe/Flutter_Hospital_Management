import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/constants/iconLinks.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/Intro_screen/introScreen2.dart';
import 'package:doctor_management/screens/Intro_screen/userSelection.dart';
import 'package:flutter/material.dart';


class Introscreen1 extends StatefulWidget {
  @override
  State<Introscreen1> createState() => _Introscreen1State();
}

class _Introscreen1State extends State<Introscreen1> {
  Constants str=Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      links.firstPage,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20), 
                    Text(
                      str.ScreenOneHeading,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8), 
                    Text(str.ScreenOneContent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSelectionPage()));
                    },
                    child: Text(str.Skip),
                  ),
                  Container(
            decoration: BoxDecoration(
              color: color.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
                icon: Icon(Icons.arrow_forward),
                color: color.cyan,
                iconSize: 35,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Introscreen2()));
            },
  ),
)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}