import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/model/meal_model.dart';
import 'package:flutter_application_4/screens/login_screen.dart';
import 'package:flutter_application_4/screens/profile_info.dart';
import 'package:flutter_application_4/servises/auth_service.dart';
import 'package:flutter_application_4/widgets/category_widget.dart';
import 'package:flutter_application_4/widgets/products_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String>categories=[
    'All',
    'Burger',
    'Frise',
    'Salad'
  ];
  String selectedItem='All';
  @override
  Widget build(BuildContext context) {
    // List<MealModel>filteredList=
    final size=MediaQuery.of(context).size;
    AuthService authService = AuthService();

    final firebaseAuth = FirebaseAuth.instance;
    return Scaffold(
      
      // drawer: Drawer(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     spacing: 15,
      //     children: [
      //       ListTile(
      //         leading: Icon(Icons.info),
      //         title: Text('Profile'),
      //         onTap: () {
      //           Navigator.of(
      //             context,
      //           ).push(MaterialPageRoute(builder: (context) => ProfileInfo()));
      //         },
      //       ),
      //       ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
      //       ListTile(
      //         leading: Icon(Icons.logout),
      //         title: Text('Logout'),
      //         onTap: () {
      //           authService.signout();
      //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
                
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        title: ListTile(
        title: Text('GoFood',style: TextStyle(
          color: Colors.white,
          fontWeight: .bold,
          fontSize: 18
        ),),
        subtitle: Text('your favorite food'),
      ), 
      actions: [
        CircleAvatar(
          child: Icon(Icons.person),
        )
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          
          width: .infinity,
          child: Column(
            
            children: [
              SizedBox(height: 20,),
             Row(
               children: [
                 Expanded(
                  flex: 3,
                   child: SizedBox(
                    // width: size.width*0.8,
                     child: Card(
                      
                       elevation: 10,
                       shadowColor: Colors.black,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(16.0),
                       ),
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                         child: Row(
                           children: [
                             Icon(
                               Icons.search, 
                               
                               size: 22,
                             ),
                             const SizedBox(width: 10),
                             Expanded(
                               child: TextField(
                      decoration: InputDecoration(
                        hintText: 'search', 
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
                 SizedBox(width: size.width*0.1,),
                 Expanded(
                  flex: 1,
                   child: Container(
                    // width: size.width*0.2,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade300,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Icon(Icons.filter_list_rounded,color: Colors.white,),
                   ),
                 )
               ],
             ),
             SizedBox(height: size.height*0.02,),
             SizedBox(
              height: size.height*0.06,
              child: ListView.builder(
                shrinkWrap: true,
                itemExtent: 100,
                scrollDirection: .horizontal,
                itemCount:categories.length ,
                itemBuilder:(context,index)=>CategoryWidget(
                  textColor: selectedItem==categories[index]?
                  Colors.white
                  :
                  Colors.black
                  ,
                  backgroundColor: selectedItem==categories[index]?
                  Color(0xCDfd4754)
                  :
                  Colors.white
                  ,
                  title: categories[index],
                  onTap: () => setState(() {
                    selectedItem=categories[index];
                  }),
                )
                 ),
             ),
             SizedBox(height: size.height*0.02,),
             StreamBuilder(stream: filter().snapshots(), builder: (context, snapshot) 
             {
              if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Center(child: CircularProgressIndicator(),);
              }
              else if(!snapshot.hasData || snapshot.data!.docs.isEmpty)
              {
                return Center(child: Text('No Products'),);
              }
              final products=snapshot.data!.docs.map((doc)=>MealModel.fromMap(doc.data() as Map<String,dynamic>, doc.id)).toList();
        
             return Expanded(
               child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:2 
                ), 
                itemBuilder: (context,index)=>ProductCard(product: products[index],onFavoriteTap: () =>addFav(products[index]) ,)),
             );
        
             }
             
             ),
             ElevatedButton(onPressed: (){
              FirebaseAuth.instance.signOut();
             }, child: Text('logout'))
            ],
          ),
        ),
      ),
      
    );
  }
  Query filter(){
    if(selectedItem=='All')
    {
      return FirebaseFirestore.instance.collection('products');

    }
    return FirebaseFirestore.instance.collection('products').where('category',isEqualTo:selectedItem );
  }

  Future<void> addFav(MealModel product)async{
    String uid=FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('usersCollection').doc(uid).collection('favorite').doc(product.id).set(product.toMap());



  }
}
