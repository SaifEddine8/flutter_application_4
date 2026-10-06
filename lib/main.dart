import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_application_4/screens/admin_dashboard.dart';
import 'package:flutter_application_4/screens/home_screen.dart';
import 'package:flutter_application_4/screens/login_screen.dart';
import 'package:flutter_application_4/screens/signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  // 1. التأكد من تحضير بيئة أداء اليدجيتس
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseAnalytics.instance.logEvent(
  //   name: 'selected_content',
  //   parameters: {
  //     'name':'start_app',
  //     'time':DateTime.now().toString(),

  //   }
  //   );
  // FirebaseAuth.instance.useAuthEmulator('localhost',9099);
  await GoogleSignIn.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: userState());
  }

  StreamBuilder<User?> userState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return FutureBuilder(
            future: FirebaseFirestore.instance.collection('usersCollection')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context,roleSnapshot)
            {
              if(!roleSnapshot.hasData)
              {
                return Scaffold(body: Center(child: CircularProgressIndicator()));

              }
              final role=roleSnapshot.data!['role'];
              if(role=='admin')
              {
                return AdminDashboard();
              }
              else if(role=='user')
              {
                return HomeScreen();
              }
              return Center(child: CircularProgressIndicator());
              

            },
          );
        }
        return LoginScreen();
      },
    );
  }
}
