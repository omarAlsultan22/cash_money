import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_spaces.dart';
import 'package:cash_money/core/constants/app_sizes.dart';
import 'package:cash_money/core/constants/app_colors.dart';
import 'package:cash_money/core/constants/app_paddings.dart';
import '../../questions/presentation/screens/start_screen.dart';
import '../../settings/presentation/screens/settings_screen.dart';
import '../../questions/presentation/screens/questions_screen.dart';


class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  static const _opacityDegree = 0.3;

  //sizes
  static const _elevation = 5.0;
  static const _iconSize = 28.0;
  static const _fontSize = 20.0;
  static const _blurRadius = 10.0;
  static const _spreadRadius = 2.0;

  //colors
  static const _black = AppColors.black;
  static const _white = AppColors.white;
  static const _brown900 = AppColors.brown_900;

  //spacing
  static const _dx = AppSizes.none;
  static const _dy = 5.0;
  static const _spacing = 200.0;
  static const _symmetricalHorizontal = 24.0;
  static const _widthSpacing = AppSizes.radius;
  static const _verticalSpacing20 = SizedBox(height: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _brown900,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _brown900,
              AppColors.brown_800,
              AppColors.brown_700,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppPaddings.large,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  Hero(
                    tag: 'app-logo',
                    child: Container(
                      height: _spacing,
                      width: _spacing,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _black.withOpacity(_opacityDegree),
                            blurRadius: _blurRadius,
                            spreadRadius: _spreadRadius,
                            offset: const Offset(_dx, _dy),
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
                  AppSpaces.height_40,
                  // Buttons Section
                  _buildMenuButton(
                    context,
                    title: 'Start',
                    icon: Icons.play_arrow_rounded,
                    page: const StartScreen(),
                    color: AppColors.successGreen,
                  ),
                  _verticalSpacing20,
                  _buildMenuButton(
                    context,
                    title: 'Questions',
                    icon: Icons.help_outline_rounded,
                    page: const QuestionsScreen(),
                    color: const Color(0xFF1565C0),
                  ),
                  _verticalSpacing20,
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
          ),)
        ,
      )
      ,
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
          padding: const EdgeInsets.symmetric(vertical: AppPaddings
              .vertical,
              horizontal: _symmetricalHorizontal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
          elevation: _elevation,
          shadowColor: _black.withOpacity(_opacityDegree),
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
            Icon(icon, color: _white, size: _iconSize),
            const SizedBox(width: _widthSpacing),
            Text(
              title,
              style: const TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.bold,
                color: _white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
