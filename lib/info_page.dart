import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox( 
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(color: Colors.lightBlue ,child: Text(
      "With Reaction you only have one shot! Based on the original url{Chain Reaction}, the atoms randomly fly around, one tap and try to catch as many atoms as possible!\n\nIn loving memory of Gaby Barsky"
    )));
  }
  
}

// Visibility(
//             maintainSize: true,
//             maintainAnimation: true,
//             maintainState: true,
//             visible: (Provider.of<StatusNotifier>(context).getStatus ==
//                     Status.userTap)
//                 ? true
//                 : false,
//             child: Column(