import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/providers/caff_provider.dart';
import 'package:caff_parser/providers/home_provider.dart';
import 'package:caff_parser/screens/caff_screen.dart';
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

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).getCaffList();
  }


  @override
  Widget build(BuildContext context) => Consumer<HomeProvider>(
    builder: (context, homeProvider, child){
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
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (contextNavigator){
                        return ChangeNotifierProvider.value(
                            value: Provider.of<CaffProvider>(context, listen: false),
                            child: const CaffScreen(id: 10,));
                      }));
                    },
                    child: CaffCard(title: homeProvider.test, imgURL: "https://images.metmuseum.org/CRDImages/ep/original/DP119115.jpg",),
                  );
                }
            )
            )
          ],
        )
      );});
  }
