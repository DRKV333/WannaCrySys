import 'package:flutter/material.dart';

class CaffCard extends StatelessWidget{

  final int id;
  final String title;
  final String imgURL;

  const CaffCard({Key? key, required this.id, required this.title, required this.imgURL}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          /*GestureDetector(
            onTap: (){},
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network("src"),
              ),
            ),
          ),*/
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