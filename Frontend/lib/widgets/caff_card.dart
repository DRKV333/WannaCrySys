import 'package:flutter/material.dart';

class CaffCard extends StatelessWidget{

  final String title;
  final String imgURL;

  const CaffCard({Key? key, required this.title, required this.imgURL}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
             SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Padding(padding: EdgeInsets.zero,)//Image.network(imgURL),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 10, top: 5),
              color: Colors.lime,
              child: Center(child: Text(title)),
            ),
          )
        ],
      ),
    );
  }

}