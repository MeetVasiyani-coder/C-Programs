import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_app/User.dart';
import 'package:matrimony_app/home_screen.dart';
import 'package:matrimony_app/my_database.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    setState(() => _isLoading = true);
    try {
      // Start animation
      _controller.forward();

      // Initialize database and load data
      await MyDatabase().initDatabase();
      await widget.users.getUserList();

      // Ensure animation completes
      if (_controller.status != AnimationStatus.completed) {
        await _controller.forward().orCancel;
      }

      // Navigate to home screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(users: widget.users),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing app: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      child: Stack(
        children: [
          Center(
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
          if (_isLoading)
            const Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
