import 'package:caff_parser/models/user_dto.dart';
import 'package:caff_parser/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final UserDto userDto;

  const HomeScreen({Key? key, required this.userDto}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
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
        body: Center(
          child: Text(userDto.username.toString()),
        ),
      );
}
