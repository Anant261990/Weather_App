import 'package:flutter/material.dart';

class AdditonalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditonalInfo({super.key, required this.icon, required this.label,required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 34,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          label,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
