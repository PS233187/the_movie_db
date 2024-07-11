import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: const Text(
            'The Movie DB',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Kite One',
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
          'Welcome!',
          style: TextStyle(fontSize: 24),
        ),
      ), // Placeholder text, replace with your actual app content
    );
  }
}
