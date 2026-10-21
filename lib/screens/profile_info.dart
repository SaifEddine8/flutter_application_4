import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/servises/auth_service.dart';
import 'package:intl/intl.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final _nameController=TextEditingController();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return Scaffold(
      body:  StreamBuilder(stream: FirebaseAuth.instance.userChanges(), 
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting)
        {
          return CircularProgressIndicator();
        }
        final user=snapshot.data;
        if(user==null)
        {
          return Center(child: Text('user not found'),);
        }
        return SizedBox(
          width: .infinity,
          child: Column(
            
            children: [
              CircleAvatar(radius: 50,child: user.photoURL==null?Icon(Icons.person):Image.network(user.photoURL!),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name : ${user.displayName}'),
                  IconButton(onPressed: ()async{
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title:Text('update name'),
                        content:Column(
                          children: [
                            TextField(
                              controller:_nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder()
                              ),)
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => {
                            _nameController.clear(),
                            Navigator.pop(context)},child: Text('cancel'),),
                          TextButton(onPressed: ()async {await AuthService.updateDisplayName(_nameController.text);
                          _nameController.clear();
                          Navigator.pop(context);
                          },child: Text('update'),)
                        ],
                        );
                    });
                  },
                   icon: Icon(Icons.edit))
                ],
              ),
              Text('Email : ${user.email}'),
              Text('Verified email : ${user.emailVerified?'yes':'no'}'),
              Text('UID${user.uid}')
            ],
          ),
        );
      }),
    );
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Profile Information'), centerTitle: true),
  //     body: Container(
  //       width: .infinity,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Container(
  //             width: MediaQuery.of(context).size.width * 0.6,
  //             height: MediaQuery.of(context).size.height * 0.16,
  //             decoration: BoxDecoration(
  //               // borderRadius: BorderRadius.circular(10),
  //               gradient: LinearGradient(
  //                 colors: [Colors.pink, Colors.white60, Colors.blue],
  //                 // begin: Alignment.topLeft,
  //                 // end: Alignment.bottomRight,
  //               ),
  //             ),
  //             child: Text('Information'),
  //           ),
  //           SizedBox(height: 20),
  //           Text('Email : ${firebaseAuth.currentUser!.email}'),
  //           Text(
  //             'Create Date : ${DateFormat('MMM,d,y').format(firebaseAuth.currentUser!.metadata.creationTime!)}',
  //           ),
  //           Text(
  //             'Last Sign In : ${DateFormat('MMM,d,y').format(firebaseAuth.currentUser!.metadata.lastSignInTime!)}',
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  }
}
