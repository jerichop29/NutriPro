import 'package:flutter/material.dart';
import 'package:nutripro/screen/terms%20of%20service/terms_of_service.dart';

class SplashscreenWidget extends StatefulWidget {
  const SplashscreenWidget({Key? key}) : super(key: key);

  @override
  _SplashscreenWidgetState createState() => _SplashscreenWidgetState();
}

class _SplashscreenWidgetState extends State<SplashscreenWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      _showTermsOfService();
    });
  }

  // Method to show Terms of Service and navigate to HomeScreen after acceptance
  void _showTermsOfService() {
    TermsOfServiceDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(76, 175, 80, 1.0),
              Color.fromRGBO(207, 251, 229, 1)
            ],
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 150,
                child: Container(
                  width: 360,
                  height: 360,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/harvester.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: 200,
                child: Text(
                  'NUTRIPRO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.82),
                    fontFamily: 'Montserrat',
                    fontSize: 25,
                    letterSpacing: -1.0,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    decoration: TextDecoration.none,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 10,
                      ),
                    ],
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
