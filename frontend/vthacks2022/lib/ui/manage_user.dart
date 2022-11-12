import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/services/authentication_service.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  @override
  Widget build(BuildContext context) {
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context);

    return Center(
      child: Column(
        children: [
          Image.network(authService.customUser.photoUrl!),
          TextButton(
            child: Text("Log Out"),
            onPressed: () {
              authService.signOutUser();
            },
          ),
        ],
      ),
    );
  }
}
