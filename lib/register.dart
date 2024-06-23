import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/login.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final _formkey = GlobalKey<FormState>();
  String email = '', password = '';
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          height: double.maxFinite,
          width: 300,
          child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Enter Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'icorrect Email';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Enter password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'icorrect password';
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = _emailController.text;
                            password = _passwordController.text;
                          });
                          register();
                        }
                      },
                      child: Text('Register')),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginpage()));
                      },
                      child: Text('Login'))
                ],
              )),
        ),
      ),
    );
  }

  //function to register the user
  register() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      const snackBar = SnackBar(
        content: Text('User Created'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => loginpage()));
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('User not Created'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
