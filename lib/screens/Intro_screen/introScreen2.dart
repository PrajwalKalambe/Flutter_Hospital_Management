import 'package:doctor_management/constants/iconLinks.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/screens/Intro_screen/userSelection.dart';
import 'package:flutter/material.dart';

class Introscreen2 extends StatefulWidget {
  @override
  State<Introscreen2> createState() => _Introscreen2State();
}

class _Introscreen2State extends State<Introscreen2> {
  Constants str=Constants();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(str.ScreenTwoHeading, style: TextStyle(fontSize: 40,color: color.cyan)),
                    SizedBox(height: 35),
                    Text(str.ScreenOneHeading, style: TextStyle(fontSize: 27)),
                    SizedBox(height: 35),
                    Text(str.ScreenTwoText1,style: TextStyle(fontSize: 22)),
                     SizedBox(height: 20),
                     Text(str.ScreenTwoText2, style: TextStyle(fontSize: 22)),
                    SizedBox(height: 20),
                    Text(str.ScreenTwoText3, style: TextStyle(fontSize: 22)),
                    SizedBox(height: 20),
                  ],
                ),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSelectionPage()));
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    links.firstPage, 
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}