import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sos_call/signup.dart';

import 'database.dart';
import 'main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showPassword = false;
  bool loading = false;

  connexion(String email, String password) async {
    try {
      setState(() {
        loading = true;
      });
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await Database.getUserData(_auth.currentUser);
      setState(() {
          loading = false;
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
                (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      if (e.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Network request failed",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Invalid email",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Wrong password",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "User not found",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "An error occured",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF3F3F3F3),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logoRed.png',
                width: 160,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Enter your email address',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFFF2121),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: email,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      prefixIcon:
                          Icon(Icons.mail, color: Colors.grey, size: 20),
                      suffixIcon: email.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  email.text = "";
                                });
                              },
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Enter your password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFFF2121),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: password,
                    onChanged: (value) {
                      setState(() {});
                    },
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                        size: 20,
                      ),
                      suffixIcon: password.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () async {
                  if (email.text.isEmpty || password.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please fill all fields",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    connexion(email.text, password.text);
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF2121),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  Color.fromRGBO(254, 254, 226, 1)),
                            ),
                          )
                        : const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Color.fromRGBO(254, 254, 226, 1),
                              fontSize: 18,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                  child: Signup(),
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 500),
                  reverseDuration: const Duration(milliseconds: 500),
                ),
                    (route) => false,
              );
              },
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "No account, please register here",
                  style: TextStyle(
                    color: Color(0xFFFF2121),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
