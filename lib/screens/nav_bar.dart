import 'package:flutter/material.dart';
import 'package:flutter_application_4/screens/cart_screen.dart';
import 'package:flutter_application_4/screens/fav_screen.dart';
import 'package:flutter_application_4/screens/home_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}
int index=0;
class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    Map<String,IconData>navItem={
  'Home':Icons.home,
  'Fav':Icons.favorite,
  'Cart':Icons.card_travel
};
List<Widget>screens=[
  HomeScreen(),
  FavScreen(),
  CartScreen()
];
    return Scaffold(
      body: IndexedStack(
        children:screens ,
        index: index,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedIconTheme: IconThemeData(color: Colors.black),
        currentIndex: index,
        backgroundColor: Colors.pink.shade300,
        items:navItem.entries.map((item)=>BottomNavigationBarItem(
          icon: Icon(item.value,),
          label: item.key,

        )).toList(),
        onTap: (value) => setState(() {
          index=value;
        }),
        
         ),
    );
  }
}