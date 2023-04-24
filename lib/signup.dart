import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sos_call/login.dart';
import 'package:sos_call/main.dart';

import 'database.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController name = TextEditingController();
  final TextEditingController surname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController otherPhone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController workAddress = TextEditingController();
  final TextEditingController medicalProblems = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showPassword = false;
  bool loading = false;
  int _genderType = 1;

  inscription(String email, String password) async {
    try {
      setState(() {
        loading = true;
      });
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _auth.currentUser!.updateDisplayName(name.text);
      Database.saveUserData(_auth.currentUser, {
        "name": name.text,
        "surname": surname.text,
        "phone": phone.text,
        "otherPhone": otherPhone.text,
        "medicalProblems": medicalProblems.text,
        "address": address.text,
        "workAddress": workAddress.text,
        "gender": _genderType == 1 ? "Male" : "Female",
        "e-mail": email,
        "password": password,
      });
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: MyHomePage(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 500),
        ),
        (route) => false,
      );
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
          ),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Invalid email address",
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Password too weak",
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "This email is already in use",
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "An error occured",
              textAlign: TextAlign.center,
            ),
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
                'Enter your name(*)',
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
                    controller: name,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Name",
                      border: InputBorder.none,
                      prefixIcon:
                          Icon(Icons.person, color: Colors.grey, size: 20),
                      suffixIcon: name.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  name.text = "";
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
                'Enter your surname(*)',
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
                    controller: surname,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Surname",
                      border: InputBorder.none,
                      prefixIcon:
                          Icon(Icons.person, color: Colors.grey, size: 20),
                      suffixIcon: surname.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  surname.text = "";
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
                'Enter your email address(*)',
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
                    keyboardType: TextInputType.emailAddress,
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
                'Enter your phone number(*)',
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
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Phone",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.phone_android,
                          color: Colors.grey, size: 20),
                      suffixIcon: phone.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  phone.text = "";
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
                'Enter another phone number for emergency(*)',
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
                    controller: otherPhone,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Phone",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.phone_android,
                          color: Colors.grey, size: 20),
                      suffixIcon: otherPhone.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  otherPhone.text = "";
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
                'Enter your address(*)',
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
                    controller: address,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Address",
                      border: InputBorder.none,
                      prefixIcon:
                          Icon(Icons.place, color: Colors.grey, size: 20),
                      suffixIcon: address.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  address.text = "";
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
                'Enter your service address',
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
                    controller: workAddress,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Address",
                      border: InputBorder.none,
                      prefixIcon:
                          Icon(Icons.place, color: Colors.grey, size: 20),
                      suffixIcon: workAddress.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  workAddress.text = "";
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
                'Enter your medical history(*)',
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
                    controller: medicalProblems,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "History",
                      border: InputBorder.none,
                      prefixIcon:
                          Icon(Icons.list, color: Colors.grey, size: 20),
                      suffixIcon: medicalProblems.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  medicalProblems.text = "";
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
                'Enter your password(*)',
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
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Gender(*)',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              children: [
                RadioListTile(
                  value: 1,
                  title: const Text("Male"),
                  groupValue: _genderType,
                  onChanged: (val) => setState(() {
                    _genderType = val!;
                  }),
                ),
                RadioListTile(
                  value: 2,
                  title: const Text("female"),
                  groupValue: _genderType,
                  onChanged: (val) => setState(() {
                    _genderType = val!;
                  }),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () async {
                  if (name.text.isEmpty ||
                      surname.text.isEmpty ||
                      phone.text.isEmpty ||
                      otherPhone.text.isEmpty ||
                      address.text.isEmpty ||
                      medicalProblems.text.isEmpty ||
                      email.text.isEmpty ||
                      password.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "please fill in all required fields",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    inscription(email.text, password.text);
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
                            "Register",
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
                    child: Login(),
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
                  "Already have an account, please login here",
                  style: TextStyle(
                    color: Color(0xFFFF2121),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
