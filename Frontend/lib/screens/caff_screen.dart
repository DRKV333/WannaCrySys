import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/widgets/circular_button.dart';
import 'package:caff_parser/widgets/comment_card.dart';
import 'package:flutter/material.dart';
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
    Provider.of<CaffProvider>(context, listen: false).getCaff(widget.id);
  }


  @override
  Widget build(BuildContext context) => Consumer<CaffProvider>(
      builder: (context, caffProvider, child) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Caff Parser'),
          actions: [
            IconButton(
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logout();
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
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 400,
                child:Container(
                  height: 400,
                  decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage("https://images.metmuseum.org/CRDImages/ep/original/DP119115.jpg")
                  )
                ),
              )
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: CircularButton(isLoading: false, text: "Download", buttonColor: Colors.lime,)),
                const Padding(padding: EdgeInsets.only(right: 20)),
                GestureDetector(
                  onTap: (){},
                  child: const Icon(Icons.edit),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                GestureDetector(
                  onTap: (){},
                  child: const Icon(Icons.delete),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
              ],
            ),
            const Divider(color: Colors.lime, thickness: 10,),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lime, width: 3.0)
                    )
                  ),
                )
            ),
            Align(
              alignment: Alignment.topRight,
              child: CircularButton(isLoading: false, text: "Comment", buttonColor: Colors.lime,),
            ),
            const Divider(color: Colors.lime, thickness: 10,),
            ListView.builder(
                itemCount: 1,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return CommentCard(name: "Valaki", comment: "Aaaaaaaaaaaaaa",
                      edit: () => caffProvider.editComment(widget.id, "content"),
                      delete: ()=> caffProvider.deleteComment(widget.id),
                  );
              }
            )
          ],
        )
      ])
    );
  }
);
}