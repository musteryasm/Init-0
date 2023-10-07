import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class learn extends StatefulWidget {
  @override
  State<learn> createState() => _learnState();
}

class _learnState extends State<learn> {
  double _sliderValue = 0.0;

  Future<void> _launchLearningApp() async {
    const url = 'com.example.finalproject/.SplashScreen://'; // Replace with your app's custom URL scheme
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Lottie.asset('assets/animation2.json', width: 300, height: 300),
            SizedBox(height: 10),
            Text(
              "Learning new languages is not only a valuable skill but also a gateway to personal and professional development. It goes beyond mere communication, offering a profound understanding of diverse cultures and perspectives. It empowers you to engage meaningfully with people from different walks of life and broadens your outlook, making you a more adaptable and culturally sensitive individual.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20, fontFamily: 'Acme'),
            ),
            SizedBox(height: 70),
            Text("Swipe Left To Learn ->",
              style: TextStyle(
                fontFamily: 'Acme',
                fontSize: 25
              ),
            )
          ],
        ),
      ),
    );
  }
}
