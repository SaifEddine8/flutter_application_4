import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuth=FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        centerTitle: true,
        
      ),
      body: SizedBox(
        width: .infinity,
        child: Column(
          crossAxisAlignment: .center,
          
          children: [
            SizedBox(height: 40,),
            Text('Hi ${firebaseAuth.currentUser!.email}'),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              firebaseAuth.signOut();
            }, child: Text('Logout'))
        
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){

      },
      child: Icon(Icons.add),),
    );
  }
}