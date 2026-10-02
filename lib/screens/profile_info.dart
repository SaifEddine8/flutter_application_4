import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth=FirebaseAuth.instance;
    return Scaffold(
      appBar:AppBar(
        title: Text('Profile Information'),
        centerTitle: true,
      ),
      body:Container(
        width: .infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.6,
              height: MediaQuery.of(context).size.height*0.16,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    Colors.pink, Colors.white60,Colors.blue],
                  // begin: Alignment.topLeft,
                  // end: Alignment.bottomRight,
                ),
              ),
              child: Text('Information'),
            ),
            SizedBox(height: 20,),
            Text('Email : ${firebaseAuth.currentUser!.email}'),
            Text('Create Date : ${DateFormat('MMM,d,y').format(firebaseAuth.currentUser!.metadata.creationTime!)}'),
            Text('Last Sign In : ${DateFormat('MMM,d,y').format(firebaseAuth.currentUser!.metadata.lastSignInTime!)}'),
          ],
        ),
      )
      );
  }
}