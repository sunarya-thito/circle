import 'package:circle/dto/gempa.dart';
import 'package:flutter/material.dart';

class GempaItem extends StatefulWidget {
  final Gempa gempa;
  const GempaItem({Key? key, required this.gempa}) : super(key: key);

  @override
  _GempaItemState createState() => _GempaItemState();
}

class _GempaItemState extends State<GempaItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.gempa.Tanggal),
            Text(widget.gempa.Coordinates),
            Text(widget.gempa.Magnitude.toString()),
            Text(widget.gempa.Kedalaman),
            Text(widget.gempa.Wilayah),
            Text(widget.gempa.Potensi),
          ],
        ),
      ),
    );
  }
}
