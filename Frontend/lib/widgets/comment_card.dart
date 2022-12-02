import 'package:flutter/material.dart';

import 'circular_button.dart';

class CommentCard extends StatelessWidget{

  final String name;
  final String comment;
  final Function() edit;
  final Function() delete;

  const CommentCard({Key? key, required this.name, required this.comment, required this.edit, required this.delete}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(
        side: BorderSide(
          color: Colors.lime,
          width: 4
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(name),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Text(comment),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){edit();},
                  child: const Icon(Icons.edit),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                GestureDetector(
                  onTap: (){delete();},
                  child: const Icon(Icons.delete),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}