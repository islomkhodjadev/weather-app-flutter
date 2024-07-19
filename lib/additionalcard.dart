import "package:flutter/material.dart";




class AdditionalInfoCard extends StatefulWidget {
  final IconData icon;
  final String text;
  final String data;

  const AdditionalInfoCard(
      {super.key, required this.icon, required this.text, required this.data});

  @override
  State<AdditionalInfoCard> createState() => _AdditionalInfoCardState();
}

class _AdditionalInfoCardState extends State<AdditionalInfoCard> {
  late IconData icon;
  late String text;
  late String data;

  @override
  void initState() {
    super.initState();
    icon = widget.icon;
    text = widget.text;
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8.0),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            data,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
