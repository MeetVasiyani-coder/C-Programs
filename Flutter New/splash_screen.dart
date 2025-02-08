import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_app/User.dart';
import 'package:matrimony_app/home_screen.dart';

class SplashScreen extends StatefulWidget {
  final User users;
  const SplashScreen({super.key, required this.users});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(users: widget.users)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF66E8),
            Color(0xFFFF6CB3),
            Color(0xFFFF778D),
            Color(0xFFFF8673),
            Color(0xFFFFAA7B),
            Color(0xFFFFC585),
            Color(0xFFFFDE92),
            Color(0xFFFFBAA3),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Forever',
                style: GoogleFonts.monteCarlo(
                  textStyle: const TextStyle(
                    fontSize: 100,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'assets/images/rings.png',
                width: 150,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
