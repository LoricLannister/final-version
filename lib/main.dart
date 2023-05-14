import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:permission_handler/permission_handler.dart';

import 'login.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return MaterialApp(
      title: 'Sos Call',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AnimatedSplashScreen(
        splashIconSize: 240,
        duration: 1000,
        backgroundColor: const Color(0xFFFF2121),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
        animationDuration: const Duration(milliseconds: 1750),
        splash: Center(
          child: Image.asset(
            "assets/logo.png",
            height: 180,
            width: 180,
            fit: BoxFit.cover,
          ),
        ),
        nextScreen:
            _auth.currentUser != null ? const MyHomePage() : const Login(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentTabIndex = 0;
  int callType = 1;
  List<geo.Placemark> actualLocation = [];
  Location location = Location();

  @override
  void initState() {
    super.initState();
    requestForPermission();
  }

  getLocation() {
    if (actualLocation.isEmpty) {
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        double latitude = (await location.getLocation()).latitude!;
        double longitude = (await location.getLocation()).longitude!;
        actualLocation = await geo
            .placemarkFromCoordinates(latitude, longitude)
            .then((location) async {
          if (location[0].country!.isNotEmpty) {
            setState(() {
              actualLocation = location;
            });
            timer.cancel();
          }
          return location;
        });
      });
    }
  }

  requestForPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      var newStatus = await Permission.location.request();
      if (newStatus.isGranted ||
          newStatus.isLimited ||
          newStatus.isRestricted) {
        getLocation();
      } else if (newStatus.isPermanentlyDenied) {
        openAppSettings();
        exit(0);
      } else if (newStatus.isDenied) {
        exit(0);
      }
    } else if (status.isGranted || status.isLimited || status.isRestricted) {
      getLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final kTabPages = [
      Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 12),
                                  Text(
                                    "Warning",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Do you want to logout?",
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await FirebaseAuth.instance
                                              .signOut()
                                              .then(
                                                (value) => Navigator
                                                    .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Login(),
                                                        ),
                                                        (route) => false),
                                              );
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.logout),
                    color: Color(0xFFFF2121),
                    iconSize: 32,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 35, 15, 5),
                child: SizedBox(
                  height: 80,
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        callType = 1;
                      });
                    },
                    contentPadding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                    leading: Image.asset(
                      'assets/Ambulance.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    horizontalTitleGap: 8,
                    title: const Text(
                      'Hospital',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        color: Color(0xFFFF2121),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: const Text(
                      'If you have an emergency, call the hospital',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: 1.25,
                      child: Radio(
                        value: 1,
                        groupValue: callType,
                        onChanged: (val) => setState(() {
                          callType = val!;
                        }),
                      ),
                    ),
                    tileColor: const Color(0xF3F3F3F3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
                child: SizedBox(
                  height: 80,
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        callType = 2;
                      });
                    },
                    contentPadding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                    leading: Image.asset(
                      'assets/Policeman.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    horizontalTitleGap: 8,
                    title: const Text(
                      'Police',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Color(0xFFFF2121),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: const Text(
                      'If you have an emergency, call the police',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: 1.25,
                      child: Radio(
                        value: 2,
                        groupValue: callType,
                        onChanged: (val) => setState(() {
                          callType = val!;
                        }),
                      ),
                    ),
                    tileColor: const Color(0xF3F3F3F3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      callType = 3;
                    });
                  },
                  contentPadding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                  leading: Image.asset(
                    'assets/Fireman.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  horizontalTitleGap: 8,
                  title: const Text(
                    'Firefighters',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      color: Color(0xFFFF2121),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: const Text(
                    'In case of fire, call here!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 1.25,
                    child: Radio(
                      value: 3,
                      groupValue: callType,
                      onChanged: (val) => setState(() {
                        callType = val!;
                      }),
                    ),
                  ),
                  tileColor: const Color(0xF3F3F3F3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 10),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color(0xFFFF2121),
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (actualLocation.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xF3928585),
                            content: Text("Unable to get your location!",
                                textAlign: TextAlign.center),
                          ),
                        );
                      } else {
                        if (actualLocation[0].isoCountryCode == 'CM') {
                          if (callType == 1) {
                            await FlutterPhoneDirectCaller.callNumber("119");
                          } else if (callType == 2) {
                            await FlutterPhoneDirectCaller.callNumber("117");
                          } else {
                            await FlutterPhoneDirectCaller.callNumber("118");
                          }
                        } else if (actualLocation[0].isoCountryCode == 'FR') {
                          if (callType == 1) {
                            await FlutterPhoneDirectCaller.callNumber("15");
                          } else if (callType == 2) {
                            await FlutterPhoneDirectCaller.callNumber("17");
                          } else {
                            await FlutterPhoneDirectCaller.callNumber("18");
                          }
                        } else if (actualLocation[0].isoCountryCode == 'BE') {
                          if (callType == 1) {
                            await FlutterPhoneDirectCaller.callNumber("112");
                          } else if (callType == 2) {
                            await FlutterPhoneDirectCaller.callNumber("101");
                          } else {
                            await FlutterPhoneDirectCaller.callNumber("112");
                          }
                        } else if (actualLocation[0].isoCountryCode == 'TR') {
                          if (callType == 1) {
                            await FlutterPhoneDirectCaller.callNumber("112");
                          } else if (callType == 2) {
                            await FlutterPhoneDirectCaller.callNumber("155");
                          } else {
                            await FlutterPhoneDirectCaller.callNumber("199");
                          }
                        } else if (actualLocation[0].isoCountryCode == 'IT') {
                          if (callType == 1) {
                            await FlutterPhoneDirectCaller.callNumber("118");
                          } else if (callType == 2) {
                            await FlutterPhoneDirectCaller.callNumber("113");
                          } else {
                            await FlutterPhoneDirectCaller.callNumber("115");
                          }
                        } else if (actualLocation[0].isoCountryCode == 'US') {
                          if (callType == 1) {
                            await FlutterPhoneDirectCaller.callNumber("911");
                          } else if (callType == 2) {
                            await FlutterPhoneDirectCaller.callNumber("911");
                          } else {
                            await FlutterPhoneDirectCaller.callNumber("911");
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xF3928585),
                              content: Text("Your country isn't supported!",
                                  textAlign: TextAlign.center),
                            ),
                          );
                        }
                      }
                    },
                    child: const Icon(
                      Icons.call,
                      color: Color(0xF3F3F3F3),
                      size: 45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const Center(
        child: Icon(
          Icons.help_rounded,
          size: 64,
          color: Color(0xFFFF2121),
        ),
      ),
    ];

    final bottomNavBarItems = [
      const BottomNavigationBarItem(
          icon: Icon(Icons.location_on_rounded), label: "Location"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.help_rounded), label: "Help"),
    ];

    final bottomNavBar = BottomNavigationBar(
      items: bottomNavBarItems,
      backgroundColor: const Color(0xFFFF2121),
      currentIndex: currentTabIndex,
      selectedItemColor: const Color(0xF3F3F3F3),
      unselectedItemColor: const Color(0xF3F3F3F3),
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          currentTabIndex = index;
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF2121),
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 10),
            child: Image.asset(
              'assets/logo.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: kTabPages[currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
