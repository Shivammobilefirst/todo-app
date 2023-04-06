import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _email = "";
  var _password = "";
  var _username = "";
  TextEditingController userController = TextEditingController();
  TextEditingController emilController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoginPage = false;

  startauthenticaion() {
    submitform(
        emilController.text, passwordController.text, userController.text);
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;

    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(value.user!.uid)
                      .set({
                    "username": username,
                    "email": email,
                  })
                });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Form(
                  child: Column(
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      controller: userController,
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey("username"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect username';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide()),
                        labelText: "Enter username",
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emilController,
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey("email"),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Incorrect Email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide()),
                      labelText: "Enter Email",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey("password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Incorrect password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide()),
                      labelText: "Enter Password",
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                          child: isLoginPage
                              ? Text(
                                  'Login',
                                )
                              : Text(
                                  'SignUp',
                                ),
                          onPressed: () {
                            startauthenticaion();
                          })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: isLoginPage
                          ? Text(
                              "Not a member",
                              style: TextStyle(color: Colors.blue),
                            )
                          : Text(
                              "Already a member ?",
                              style: TextStyle(color: Colors.blue),
                            ),
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
