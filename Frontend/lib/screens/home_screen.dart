import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/caff_card.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).getCaffList();
  }


  @override
  Widget build(BuildContext context) => Consumer<HomeProvider>(
    builder: (context, homeProvider, child){
      //homeProvider.getCaffList();
    return Scaffold(
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
        body: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery
                        .of(context)
                        .size
                        .width * 0.5,
                    childAspectRatio: 2 / 2.5,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10
                ),
                itemCount: 10,
                itemBuilder: (BuildContext context, index) {
                  return CaffCard(id: 0, title: homeProvider.test, imgURL: "img",);
                }
            )
            )
          ],
        )
      );});
  }
