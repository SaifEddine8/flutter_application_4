import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/screens/login_screen.dart';
import 'package:flutter_application_4/screens/profile_info.dart';
import 'package:flutter_application_4/servises/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();

    final firebaseAuth = FirebaseAuth.instance;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15,
          children: [
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => ProfileInfo()));
              },
            ),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                authService.signout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
                
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('Home Screen'), centerTitle: true),
      body: SizedBox(
        width: .infinity,
        child: Column(
          crossAxisAlignment: .center,

          children: [
            SizedBox(height: 40),
            Text('Hi ${firebaseAuth.currentUser!.email}'),
            SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
