import "package:flutter/material.dart";

// we must get the card object and make it separate class

class ForecastCard extends StatefulWidget {
  final String time;
  final IconData icon;
  final String dagree;

  const ForecastCard(
      {super.key,
      required this.time,
      required this.icon,
      required this.dagree});

  @override
  State<ForecastCard> createState() => _ForecastCardState();
}

class _ForecastCardState extends State<ForecastCard> {
  late String time;
  late IconData icon;
  late String dagree;


  
  @override
  void initState() {
    super.initState();
    time = widget.time;
    icon = widget.icon;
    dagree = widget.dagree;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child:  Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Icon(icon, size: 32),
            const SizedBox(height: 8.0),
            Text(dagree),
          ],
        ),
      ),
    );
  }
}
