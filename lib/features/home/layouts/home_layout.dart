import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../questions/presentation/screens/start_screen.dart';
import '../../user_info/presentation/screens/settings_screen.dart';
import '../../questions/presentation/screens/questions_screen.dart';


class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  static const value = 200.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3E2723),
              Color(0xFF4E342E),
              Color(0xFF5D4037),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  Hero(
                    tag: 'app-logo',
                    child: Container(
                      height: value,
                      width: value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/cm1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Buttons Section
                  _buildMenuButton(
                    context,
                    title: 'Start',
                    icon: Icons.play_arrow_rounded,
                    page: const StartScreen(),
                    color: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    title: 'Questions',
                    icon: Icons.help_outline_rounded,
                    page: const QuestionsScreen(),
                    color: const Color(0xFF1565C0),
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    title: 'Settings',
                    icon: Icons.settings_rounded,
                    page: const SettingsScreen(),
                    color: const Color(0xFFEF6C00),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {
    required String title,
    required IconData icon,
    required Widget page,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => page,
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
