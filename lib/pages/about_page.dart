import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: const Text(
            'Movie App',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Ink Free',
              fontSize: 30,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black, // Adjusted background color
          elevation: 10,
          shadowColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'about',
          style: TextStyle(fontSize: 24),
        ),
      ), // Placeholder text, replace with your actual app content
    );
  }
}
