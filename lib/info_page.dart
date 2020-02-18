import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue.withOpacity(0.8),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Text(
              "With Reaction you only have one shot! Based on the original url{Chain Reaction}, the atoms randomly fly around, one tap and try to catch as many atoms as possible!\n\nIn loving memory of Gaby Barsky",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )));
  }
}
