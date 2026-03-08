import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_numbers.dart';
import 'package:cash_money/core/constants/app_paddings.dart';
import '../../../core/presentation/widgets/app_spacing.dart';
import '../../questions/presentation/screens/start_screen.dart';
import '../../user_info/presentation/screens/settings_screen.dart';
import '../../questions/presentation/screens/questions_screen.dart';


class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  static const _black = AppColors.black;

  @override
  Widget build(BuildContext context) {
    const value = 200.0;
    const brown900 = AppColors.brown_900;
    const verticalSpacing20 = SizedBox(height: 20.0);

    return Scaffold(
      backgroundColor: brown900,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              brown900,
              AppColors.brown_800,
              AppColors.brown_700,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppPaddings.paddingAll_24,
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
                            color: _black.withOpacity(0.3),
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
                  AppSpacing.height_40,
                  // Buttons Section
                  _buildMenuButton(
                    context,
                    title: 'Start',
                    icon: Icons.play_arrow_rounded,
                    page: const StartScreen(),
                    color: AppColors.green800,
                  ),
                  verticalSpacing20,
                  _buildMenuButton(
                    context,
                    title: 'Questions',
                    icon: Icons.help_outline_rounded,
                    page: const QuestionsScreen(),
                    color: const Color(0xFF1565C0),
                  ),
                  verticalSpacing20,
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
    const white = AppColors.white;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppNumbers.twelve),
          ),
          elevation: 5,
          shadowColor: _black.withOpacity(0.3),
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
            Icon(icon, color: white, size: 28),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
