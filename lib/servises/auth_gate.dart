import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/screens/admin_dashboard.dart';
import 'package:flutter_application_4/screens/login_screen.dart';
import 'package:flutter_application_4/screens/nav_bar.dart';
import 'package:flutter_application_4/screens/verification_screen.dart';
import 'package:flutter_application_4/servises/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.authState(),
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
              final user=snapshot.data;
              if(user==null)
              {return LoginScreen();}
              else if(!user.emailVerified)
              {
                return VerificationScreen();
              }
              else if(user.emailVerified)
              {
                final role=roleSnapshot.data!['role'];
              if(role=='admin')
              {
                return AdminDashboard();
              }
              else if(role=='user')
              {
                return NavBar();
              }
             
              }
              // print('object');
              
               return Center(child: CircularProgressIndicator());

            },
          );
        }
        return LoginScreen();
      },
    );;
  }
}