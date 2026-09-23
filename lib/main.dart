import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_application_4/screens/home_screen.dart';
import 'package:flutter_application_4/screens/login_screen.dart';
import 'package:flutter_application_4/screens/signup_screen.dart';

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

  runApp(MyApp());
  
}


class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: userState(),
    );
  }
    StreamBuilder<User?> userState()
  {
    return StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(),
    builder: (context,snapshot){
      if(snapshot.connectionState==ConnectionState.waiting)
      {
        return CircularProgressIndicator();
      }
      else if(snapshot.hasData)
      {
        return HomeScreen();
      }
      return LoginScreen();
    });
    
  }
    
  }
