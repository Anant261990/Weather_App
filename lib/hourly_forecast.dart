import 'package:flutter/material.dart';

class HorlyForecast extends StatelessWidget {
  final String time;
  final String temprature;
  final IconData icon;

  const HorlyForecast({super.key,required this.time,required this.temprature, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(time,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.fade,),
            const SizedBox(
              height: 8,
            ),
            Icon(icon, size: 32),
            const SizedBox(
              height: 8,
            ),
            Text(temprature,
                style: TextStyle(
                  fontSize: 15,
                )),
          ],
        ),
      ),
    );
  }
}
