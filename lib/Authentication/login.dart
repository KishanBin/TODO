import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/Pages/home.dart';
import 'package:todo/Authentication/register.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final _formkey = GlobalKey<FormState>();
  String email = '', password = '';
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  String logged = 'unknown';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('login Screen'),
        automaticallyImplyLeading: false,
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
                        return 'Icorrect Email';
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
                          userLogin();
                        }
                      },
                      child: Text('Login')),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => register()));
                      },
                      child: Text('Register'))
                ],
              )),
        ),
      ),
    );
  }

  userLogin() async {
    Center(
      child: CircularProgressIndicator(),
    );
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        setState(() {
          logged = 'known';
        });
      });
      var pref = await SharedPreferences.getInstance();
      pref.setString('LoggedUser', logged);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homepage()));
    } on FirebaseAuthException catch (e) {
      String? error = e.message;
      log(error.toString());
    }
  }

  Future<void> checkUser() async {
    var pref = await SharedPreferences.getInstance();
    var check = pref.getString('LoggedUser');

    if (check == "known") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homepage()));
    }
  }
}
