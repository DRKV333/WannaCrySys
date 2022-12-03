import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/widgets/edit_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getCurrentUser();
    });
  }

  Future<void> _getCurrentUser() async {
    await Provider.of<AuthProvider>(context, listen: false).getCurrentUser();
  }

  Future<void> _showEditProfileDialog() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    var result = await showDialog(
      context: context,
      builder: (dContext) => ChangeNotifierProvider.value(
        value: authProvider,
        child: const EditProfileDialog(),
      ),
    );

    if (result != null) {
      await _getCurrentUser();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profile'),
          actions: [
            IconButton(
              onPressed: _showEditProfileDialog,
              tooltip: 'Edit profile',
              icon: const Icon(Icons.edit),
            )
          ],
        ),
        body: Consumer<AuthProvider>(
          builder: (_, authProvider, __) => Container(
            margin: const EdgeInsets.all(24.0),
            child: Selector<AuthProvider, bool>(
              selector: (_, authProvider) => authProvider.isLoading,
              builder: (_, bool isLoading, __) => isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (authProvider.userDto != null
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.account_circle,
                                  size: 96,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name: ${authProvider.userDto!.name}"),
                                    Text(
                                        "Username: ${authProvider.userDto!.username}"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const Center(
                          child: Text('Error while loading user'),
                        )),
            ),
          ),
        ),
      );
}
