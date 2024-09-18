import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../pages/cartpage.dart';
import '../pages/homepage1.dart';
import '../pages/profilepage.dart';
import '../pages/shoppage.dart';

class MyCustomBottomNavBar extends StatefulWidget {
  final int initialIndex;

  const MyCustomBottomNavBar({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MyCustomBottomNavBarState createState() => _MyCustomBottomNavBarState();
}

class _MyCustomBottomNavBarState extends State<MyCustomBottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.black87,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: 'Steps'),
        BottomNavigationBarItem(icon: Icon(Icons.spa), label: 'Health'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        // Handle navigation based on the selected index
        switch (index) {
          case 0:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
            break;
          case 1:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShopPage()));
            break;
          case 2:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CartPage()));
            break;
          case 3:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            break;
        }
      },
    );
  }
}

/*
class MyCustomBottomNavBar extends StatefulWidget {
  const MyCustomBottomNavBar({Key? key}) : super(key: key);
  //final ValueChanged<int> onIndexChanged;
  //MyCustomBottomNavBar({required this.onIndexChanged});
  @override
  _MyCustomBottomNavBarState createState() => _MyCustomBottomNavBarState();
}

class _MyCustomBottomNavBarState extends State<MyCustomBottomNavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.black87,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.spa), label: 'Health'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        // Add more items as needed
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        //widget.onIndexChanged(index);
        // Handle navigation based on the selected index
        switch (index) {
          case 0:

          // Navigate to the Home page
            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            break;
          case 1:
          // Navigate to the Search page
            Navigator.push(context, MaterialPageRoute(builder: (context) => ShopPage()));
            break;
          case 2:
          // Navigate to the Cart page
            Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
            break;
          case 3:
           // Navigate to the Profile page
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            break;
        // Add more cases for other items
        }
      },
    );
  }
}

 */




