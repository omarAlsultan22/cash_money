import 'package:cash_money/modules/sttings_screen/settings_screen.dart';
import '../modules/questions_screen/questions_screen.dart';
import '../modules/start_screen/start_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


  Widget buildHomeScreen(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.brown[900],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.brown[900]!,
              Colors.brown[800]!,
              Colors.brown[700]!,
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
                      height: 200,
                      width: 200,
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
                    color: Colors.green[800]!,
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    title: 'Questions',
                    icon: Icons.help_outline_rounded,
                    page: const QuestionsScreen(),
                    color: Colors.blue[800]!,
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    title: 'Settings',
                    icon: Icons.settings_rounded,
                    page: const SettingsScreen(),
                    color: Colors.orange[800]!,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, {
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
