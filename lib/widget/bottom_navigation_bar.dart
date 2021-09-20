import 'package:flutter/material.dart';
import 'package:soft_scanner/screens/bag_screen.dart';
import 'package:soft_scanner/screens/history_screen.dart';
import 'package:soft_scanner/widget/float_button_k.dart';

class BottomNavigationBarBag extends StatefulWidget {
  const BottomNavigationBarBag({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarBagState createState() => _BottomNavigationBarBagState();
}

class _BottomNavigationBarBagState extends State<BottomNavigationBarBag> {
  int _currentIndex = 0;    
  @override
  Widget build(BuildContext context) {
    
    final _kTabPages = [BagScreen(), HistoryScreen()];
    final _kBottomNavBarItems = [
      BottomNavigationBarItem(
          icon: Icon(Icons.business_center), label: 'Рюкзак'),
      BottomNavigationBarItem(icon: Icon(Icons.history), label: 'История')
    ];

    final bottomNavBar = BottomNavigationBar(

      currentIndex: _currentIndex, 
      items: _kBottomNavBarItems,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
    return MaterialApp(
      home: Scaffold(
        body: _kTabPages[_currentIndex],
        bottomNavigationBar: bottomNavBar,
        floatingActionButton: FloatButtonK(),
      ),
    );
  }
}
