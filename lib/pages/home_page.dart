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
              fontFamily: 'Kit One',
              fontSize: 30,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF090C1C),
        ),
      ),
      backgroundColor: Colors.black,
      body: const Center(

      ), //
    );
  }
}
