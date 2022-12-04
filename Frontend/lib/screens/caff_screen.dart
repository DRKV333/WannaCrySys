import 'package:caff_parser/providers/caff_provider.dart';
import 'package:caff_parser/screens/edit_caff_screen.dart';
import 'package:caff_parser/utils/globals.dart';
import 'package:caff_parser/widgets/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CaffScreen extends StatefulWidget {
  final int id;

  const CaffScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CaffScreenState();
}

class _CaffScreenState extends State<CaffScreen> {
  final GlobalKey<FormState> _addCommentFormKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Provider.of<CaffProvider>(context, listen: false).caffId = widget.id;
    Provider.of<CaffProvider>(context, listen: false).getCaff();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<CaffProvider>(builder: (context, caffProvider, child) {
        return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(caffProvider.caff.title!),
                ),
                body: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      Column(
                        children: [
                          caffProvider.caff.imgURL != null
                              ? Align(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                      height: 400,
                                      child: Container(
                                        height: 400,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    "${Globals.baseIp}/${caffProvider.caff.imgURL!}"))),
                                      )),
                                )
                              : const Text("Loading Image"),
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 7, top: 2),
                              child: Text(
                                "Created: ${caffProvider.caff.createdDate?.substring(0, 10)}",
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 7, top: 2),
                              child: Text(
                                "Owner: ${caffProvider.caff.ownerName}",
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 7, top: 2),
                              child: Text(
                                "Number of purchases: ${caffProvider.caff.numberOfPurchases}",
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    if (caffProvider.caff.isPurchased) {
                                      var status =
                                          await Permission.storage.status;
                                      if (status.isDenied) {
                                        await Permission.storage.request();
                                      }
                                      caffProvider.downloadCaff();
                                    } else {
                                      caffProvider.purchaseCaff();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.lime),
                                  child: caffProvider.caff.isPurchased
                                      ? const Text("Download")
                                      : const Text("Purchase")),
                              const Padding(
                                  padding: EdgeInsets.only(right: 20)),
                              caffProvider.canModify(caffProvider.caff.isOwner)
                                  ? IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ChangeNotifierProvider
                                                          .value(
                                                        value: caffProvider,
                                                        child:
                                                            const EditCaffScreen(),
                                                      )),
                                            )
                                            .then(
                                                (_) => caffProvider.getCaff());
                                      },
                                      tooltip: 'Edit CAFF',
                                      icon: const Icon(Icons.edit),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.zero,
                                    ),
                              const Padding(
                                  padding: EdgeInsets.only(right: 10)),
                              caffProvider.canModify(caffProvider.caff.isOwner)
                                  ? IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text("Delete caff"),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Cancel")),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        caffProvider
                                                            .deleteCaff();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Delete")),
                                                ],
                                              );
                                            });
                                      },
                                      tooltip: 'Delete CAFF',
                                      icon: const Icon(Icons.delete),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.zero,
                                    ),
                              const Padding(padding: EdgeInsets.only(right: 10))
                            ],
                          ),
                          const Divider(
                            color: Colors.lime,
                            thickness: 10,
                          ),
                          Form(
                            key: _addCommentFormKey,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  controller: caffProvider.commentController,
                                  minLines: 5,
                                  maxLines: 10,
                                  validator: Globals.validateComment,
                                  decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.lime, width: 3.0))),
                                )),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_addCommentFormKey.currentState
                                        ?.validate() ??
                                    false) {
                                  caffProvider.addComment(widget.id,
                                      caffProvider.commentController.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.lime),
                              child: const Text("Comment"),
                            ),
                          ),
                          const Divider(
                            color: Colors.lime,
                            thickness: 10,
                          ),
                          ListView.builder(
                              itemCount: caffProvider.commentList.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CommentCard(
                                  comment: caffProvider.commentList[index],
                                  canModify: caffProvider.canModify(
                                      caffProvider.commentList[index].isOwner),
                                  edit: (commentId, content) => caffProvider
                                      .editComment(commentId, content),
                                  delete: (commentId) =>
                                      caffProvider.deleteComment(commentId),
                                );
                              })
                        ],
                      )
                    ])));
      });
}
