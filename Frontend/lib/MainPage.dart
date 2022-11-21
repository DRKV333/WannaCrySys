import 'package:caff_parser/network/main_service.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{

  @override
  void initState() {
    super.initState();
    MainService().getCaffList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildMain(context),
    );
  }

  Widget buildMain(BuildContext context){
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3),
        ),
        const Align(
          alignment: Alignment.topCenter,
          child: Text("AA"),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Expanded(
          child: RefreshIndicator(
              onRefresh: () async {
                //Clear list
                //Fetch data
              },
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
                      childAspectRatio: 2 / 2.5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10
                  ),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, index){
                    return const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text("ELEMEK")
                    );
                  }
              )
          ),
        )
      ],
    );
  }
}