import 'package:flutter/material.dart';

class CaffCard extends StatelessWidget{

  final String title;
  final String imgURL;

  const CaffCard({Key? key, required this.title, required this.imgURL}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        children: [
             SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(imgURL),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              color: Colors.lime,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

}