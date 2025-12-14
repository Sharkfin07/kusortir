import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LargeLogo extends StatelessWidget {
  const LargeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color logoColor = isDark ? Colors.white : Colors.black;
    return Column(
      children: [
        SvgPicture.asset(
          "assets/icons/kusortir-icon.svg",
          width: 100,
          colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
        ),
        Text(
          "Kusortir",
          style: TextStyle(
            color: logoColor,
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class SmallLogo extends StatelessWidget {
  final String text;

  const SmallLogo({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color logoColor = isDark ? Colors.white : Colors.black;
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/kusortir-icon.svg",
          width: 20,
          colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: logoColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
