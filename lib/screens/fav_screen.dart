import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/model/meal_model.dart';
import 'package:flutter_application_4/widgets/fav_card.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(stream: FirebaseFirestore.instance.collection('usersCollection').doc(firebaseAuth.currentUser!.uid).collection('favorite').snapshots(), 
    builder: (context,snapshot)
    {
      if(snapshot.connectionState==ConnectionState.waiting)
      {
        return Center(child: CircularProgressIndicator(),);

      }
      else if(snapshot.data!.docs.isEmpty)
      {
        return Center(child: Text('favorite screen is empty'),);
      }
      final favorites=snapshot.data!.docs.map((fav)=>MealModel.fromMap(fav.data(), fav.id)).toList();
      return ListView.builder(
        itemCount:favorites.length ,
        itemBuilder:(context,index)=>FavoriteCard(meal: favorites[index], onTap: (){})
         );
    })
    ;
  }
}