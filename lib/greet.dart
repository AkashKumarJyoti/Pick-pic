import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gallery/ui.dart';
import 'util/hexcolor.dart';

class Greeting extends StatefulWidget {
  final String name;
  const Greeting({required this.name, Key? key}) : super(key: key);

  @override
  State<Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> {
  final Color _purple = HexColor("#6908D6");
  String getFirstName() {
    return widget.name.split(" ")[0];
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      navigateToBillSplitter();
    });
  }

  void navigateToBillSplitter() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ImageUpload(name: widget.name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _purple.withOpacity(0.2),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Registering ${getFirstName()}",
                style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
              ),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
