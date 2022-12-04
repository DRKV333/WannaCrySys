import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/providers/caff_provider.dart';
import 'package:caff_parser/providers/home_provider.dart';
import 'package:caff_parser/screens/add_caff_screen.dart';
import 'package:caff_parser/screens/caff_screen.dart';
import 'package:caff_parser/screens/profile_screen.dart';
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
    _getCaffList();
  }

  void _getCaffList() =>
      Provider.of<HomeProvider>(context, listen: false).getCaffList();

  void _navigateToProfileScreen() {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
                value: authProvider,
                child: const ProfileScreen(),
              )),
    );
  }

  Future<void> _navigateToAddCaffScreen() async {
    CaffProvider caffProvider =
        Provider.of<CaffProvider>(context, listen: false);
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
                value: caffProvider,
                child: const AddCaffScreen(),
              )),
    );

    if (result != null) {
      _getCaffList();
    }
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<HomeProvider>(builder: (context, homeProvider, child) {
        return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Caff Parser'),
                leading: IconButton(
                  onPressed: _navigateToProfileScreen,
                  tooltip: 'Profile',
                  icon: const Icon(Icons.account_circle),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                    },
                    tooltip: 'Logout',
                    icon: const Icon(Icons.logout),
                  )
                ],
              ),
              body: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextField(
                        controller: homeProvider.searchController,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        homeProvider.getCaffList();
                      },
                      child: const Text("Search")),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Expanded(
                    child: homeProvider.caffList.isNotEmpty
                        ? GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent:
                                        MediaQuery.of(context).size.width * 0.5,
                                    childAspectRatio: 2 / 2.5,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 10),
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: homeProvider.caffList.length,
                            itemBuilder: (BuildContext context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (contextNavigator) {
                                    return ChangeNotifierProvider.value(
                                        value: Provider.of<CaffProvider>(
                                            context,
                                            listen: false),
                                        child: CaffScreen(
                                            id: homeProvider
                                                .caffList[index].id));
                                  })).then((_) => homeProvider.getCaffList());
                                },
                                child: CaffCard(
                                  title: homeProvider.caffList[index].title,
                                  imgURL: homeProvider.caffList[index].imgURL,
                                ),
                              );
                            })
                        : const Center(
                            child: Text('No CAFFs were found'),
                          ),
                  )
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
