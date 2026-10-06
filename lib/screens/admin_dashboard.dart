import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/model/meal_model.dart';
import 'package:flutter_application_4/servises/auth_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

  List<String>categories=['All','Burger','Frise','Salad'];

class _AdminDashboardState extends State<AdminDashboard> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();  
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imgController = TextEditingController();
  String selectedCategory=categories[0];
  @override
  Widget build(BuildContext context) {
    
    AuthService authService = AuthService();
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard'), centerTitle: true,
      backgroundColor: Colors.pink[300],
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            authService.signout();
            // Handle logout logic here
          },
        ),
      ]
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                
              ),
              child: Column(
                children: [
                  Text('Add New Product', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: productNameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  DropdownButtonFormField(
                    initialValue: selectedCategory,
                    items: categories.map((category)=>DropdownMenuItem(value: category,child: Text(category))).toList(), 
                    onChanged:(newValue)=>setState(() {
                    selectedCategory=newValue!;
                  }) ,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      
                    ),
                  ),),
                   SizedBox(height: 12.0),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      
                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(15.0),
                        
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: imgController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                       MealModel newProduct=MealModel(
                          id: FirebaseFirestore.instance.collection('product').doc().id,
                          name: productNameController.text,
                          price: double.parse(priceController.text),
                          description: descriptionController.text,
                          img: imgController.text,
                          category: selectedCategory
                        );
                        await addProduct(newProduct);
                      },
                      child: Text('Add Product',style: TextStyle(
                        color: Colors.white
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Future<void>addProduct(MealModel mealModel)
  async{
    final docRef=FirebaseFirestore.instance.collection('products').doc();
    mealModel=mealModel.copyWith(id: docRef.id);
    await docRef.set(mealModel.toMap());
    
    

    
  }
}