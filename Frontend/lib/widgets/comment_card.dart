import 'package:caff_parser/models/comment_dto.dart';
import 'package:caff_parser/utils/globals.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final CommentDto comment;
  final bool canModify;
  final Function(int, String) edit;
  final Function(int) delete;

  final TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> _editCommentFormKey = GlobalKey();

  CommentCard(
      {Key? key,
      required this.comment,
      required this.edit,
      required this.delete,
      required this.canModify})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:
          const StadiumBorder(side: BorderSide(color: Colors.lime, width: 4)),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
                "${comment.userName} : ${comment.createdDate.substring(0, 16)}"),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Text(comment.content),
            const Padding(padding: EdgeInsets.only(top: 5)),
            canModify
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Edit comment"),
                                  content: Form(
                                    key: _editCommentFormKey,
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      minLines: 5,
                                      maxLines: 10,
                                      validator: Globals.validateComment,
                                      controller: controller,
                                      decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.lime,
                                                  width: 3.0))),
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel")),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (_editCommentFormKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            edit(comment.id, controller.text);
                                            Navigator.of(context).pop();
                                            controller.text = "";
                                          }
                                        },
                                        child: const Text("Edit")),
                                  ],
                                );
                              });
                        },
                        child: const Icon(Icons.edit),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 10)),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Delete comment"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel")),
                                    ElevatedButton(
                                        onPressed: () {
                                          delete(comment.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Delete")),
                                  ],
                                );
                              });
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  )
                : const Padding(
                    padding: EdgeInsets.zero,
                  ),
          ],
        ),
      ),
    );
  }
}
