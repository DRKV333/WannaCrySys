import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/widgets/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/caff_provider.dart';

class CaffScreen extends StatefulWidget {

  final int id;

  const CaffScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CaffScreenState();
}

class _CaffScreenState extends State<CaffScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<CaffProvider>(context, listen: false).caffId = widget.id;
    Provider.of<CaffProvider>(context, listen: false).getCaff();
  }


  @override
  Widget build(BuildContext context) => Consumer<CaffProvider>(
      builder: (context, caffProvider, child) {
    return GestureDetector(
        onTap: (){FocusScope.of(context).requestFocus(FocusNode());},
        child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Caff Parser'),
          actions: [
            IconButton(
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false).logout();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children:[
      Column(
          children: [
            caffProvider.caff.imgURL != null ?
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 400,
                child:Container(
                  height: 400,
                  decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage("http://192.168.1.99:8080/${caffProvider.caff.imgURL!}")
                  )
                ),
              )
              ),
            ) : const Text("Loading Image"),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 7),
                child: Text("Title: ${caffProvider.caff.title}", style: const TextStyle(fontSize: 17),),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 7, top: 2),
                child: Text("Created: ${caffProvider.caff.createdDate?.substring(0,10)}", style: const TextStyle(fontSize: 17),),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 7, top: 2),
                child: Text("Owner: ${caffProvider.caff.ownerName}", style: const TextStyle(fontSize: 17),),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 7, top: 2),
                child: Text("Number of purchases: ${caffProvider.caff.numberOfPurchases}", style: const TextStyle(fontSize: 17),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      var status = await Permission.storage.status;
                      if(status.isDenied){
                        await Permission.storage.request();
                      }
                      caffProvider.downloadCaff();
                      },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.lime),
                    child: caffProvider.caff.isPurchased ? const Text("Download") : const Text("Purchase")
                ),
                const Padding(padding: EdgeInsets.only(right: 20)),
                caffProvider.canModify() ?
                GestureDetector(
                  onTap: (){},
                  child: const Icon(Icons.edit),
                ) : const Padding(padding: EdgeInsets.zero,),
                const Padding(padding: EdgeInsets.only(right: 10)),
                caffProvider.canModify() ?
                GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete caff"),
                            actions: [
                              ElevatedButton(
                                  onPressed: (){Navigator.of(context).pop();},
                                  child: const Text("Cancel")
                              ),
                              ElevatedButton(
                                  onPressed: (){
                                    caffProvider.deleteCaff();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Delete")
                              ),
                            ],
                          );
                        }
                    );
                  },
                  child: const Icon(Icons.delete),
                ) : const Padding(padding: EdgeInsets.zero,),
                const Padding(padding: EdgeInsets.only(right: 10))
              ],
            ),
            const Divider(color: Colors.lime, thickness: 10,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: caffProvider.commentController,
                  minLines: 5,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lime, width: 3.0)
                    )
                  ),
                )
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () {caffProvider.addComment(widget.id, caffProvider.commentController.text);},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lime),
                child: const Text("Comment"),
              ),
            ),
            const Divider(color: Colors.lime, thickness: 10,),
            ListView.builder(
                itemCount: caffProvider.commentList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return CommentCard(comment: caffProvider.commentList[index], canModify: caffProvider.canModify(),
                      edit: (commentId, content) => caffProvider.editComment(commentId, content),
                      delete: (commentId)=> caffProvider.deleteComment(commentId),
                  );
              }
            )
          ],
        )
      ])
    ));
  }
);
}