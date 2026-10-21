import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/model/meal_model.dart';
import 'package:flutter_application_4/widgets/product_admin_card.dart';
import 'package:flutter_application_4/widgets/products_card.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: Text('producs'),
        centerTitle: true,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, productsSnapshots) {
          if (productsSnapshots.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (!productsSnapshots.hasData) {
            return Center(child: Text('No Products'));
          }
          final products = productsSnapshots.data!.docs
              .map((doc) => MealModel.fromMap(doc.data(), doc.id))
              .toList();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => ProductAdminCard(
              product: products[index],
              delIcon: IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('products')
                      .doc(products[index].id)
                      .delete();
                },
                icon: Icon(Icons.delete),
              ),
              updateIcon: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Edit product'),
                      content: TextField(controller: nameController),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('products')
                                .doc(products[index].id)
                                .update({'name': nameController.text});
                            Navigator.pop(context);
                          },
                          child: Text('Update'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.edit),
              ),
            ),
          );
        },
      ),
    );
  }
}
