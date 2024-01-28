import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:elevation/services/elevation.dart';


bool isDigit(String string) {
  return int.tryParse(string) != null;
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? _timer;
  String elevation = '';
  bool idle = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), updateElevation);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  Future<void> updateElevation(Timer timer) async {
    if (idle) {
      setState(() {
        idle = false;
      });
      final newElevation = await fetchElevation();
      setState(() {
        elevation = newElevation;
        idle = true;
      });
    }
  }

  Widget showElevation() {
    if (isDigit(elevation)) {
      return Text(
        '${elevation} m',
        style: elevationTextStyle(100.0),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitFadingFour(
            color: Colors.white,
            size: 100.0,
          ),
          const SizedBox(height: 10.0),
          Text(
            elevation,
            style: elevationTextStyle(32.0),
          ),
        ],
      );
    }
  }

  TextStyle elevationTextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      color: Colors.white,
      fontFamily: 'IndieFlower',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: showElevation(),
        ),
      ),
    );
  }
}
