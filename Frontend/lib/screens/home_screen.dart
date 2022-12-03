import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/providers/caff_provider.dart';
import 'package:caff_parser/providers/home_provider.dart';
import 'package:caff_parser/screens/add_caff_screen.dart';
import 'package:caff_parser/screens/caff_screen.dart';
import 'package:caff_parser/widgets/caff_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  void _navigateToAddCaffScreen() {
    CaffProvider caffProvider = Provider.of<CaffProvider>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: caffProvider,
            child: const AddCaffScreen(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<HomeProvider>(builder: (context, homeProvider, child) {
        return GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(FocusNode());},
        child: Scaffold(
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
          body: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: homeProvider.searchController,
                  )
              ),
              ElevatedButton(
                  onPressed: (){homeProvider.getCaffList();},
                  child: const Text("Search")
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                          MediaQuery.of(context).size.width * 0.5,
                          childAspectRatio: 2 / 2.5,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10
                      ),
                      itemCount: homeProvider.caffList.length,
                      itemBuilder: (BuildContext context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (contextNavigator) {
                                  return ChangeNotifierProvider.value(
                                      value: Provider.of<CaffProvider>(context, listen: false),
                                      child: CaffScreen(id: homeProvider.caffList[index].id)
                                  );
                                })).then((_) => homeProvider.getCaffList());
                          },
                          child: CaffCard(
                            title: homeProvider.caffList[index].title,
                            imgURL: homeProvider.caffList[index].imgURL,
                          ),
                        );
                      }))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _navigateToAddCaffScreen,
            tooltip: 'Add CAFF',
            child: const Icon(Icons.add),
          ),
        ));
      });
  }
