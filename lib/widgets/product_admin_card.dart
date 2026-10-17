import 'package:flutter/material.dart';
import 'package:flutter_application_4/model/meal_model.dart';

class ProductAdminCard extends StatelessWidget {
  final MealModel product;
  final Widget delIcon;
  final Widget updateIcon;
  const ProductAdminCard({
    super.key,
    required this.product,
    required this.delIcon,
    required this.updateIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            children: [
              Text(product.category),
              SizedBox(width: 15),
              Text(product.name),
            ],
          ),
          Row(children: [updateIcon, delIcon]),
        ],
      ),
    );
  }
}
