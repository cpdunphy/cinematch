import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/services/authentication_service.dart';

// this is the file that talks about how to log on a new user onto the platform

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggingIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<AuthenticationService>(
      builder: (context, authService, child) {
        return SafeArea(
          child: Center(
            child: ListView(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      "Cinematch",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: !isLoggingIn
                      ? TextField(
                          controller: _displayNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Display Name',
                          ),
                        )
                      : const SizedBox(width: 0, height: 0),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                  child: isLoggingIn
                      ? TextButton(
                          onPressed: () {
                            //forgot password screen
                          },
                          child: const Text(
                            'Forgot Password',
                          ),
                        )
                      : const SizedBox(width: 0, height: 20),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: Text(
                      isLoggingIn ? 'Login' : 'Register',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    // buttonStyle: ButtonStyle(shape: OutlinedBorder),
                    onPressed: () async {
                      if (isLoggingIn) {
                        await authService.signInUser(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      } else {
                        await authService.registerUser(
                          _displayNameController.text.trim(),
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    Text(isLoggingIn
                        ? 'Need an account?'
                        : 'Already have an account?'),
                    TextButton(
                      child: Text(
                        isLoggingIn ? 'Register' : 'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        setState(() {
                          isLoggingIn = !isLoggingIn;
                        });
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
