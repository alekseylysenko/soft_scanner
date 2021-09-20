import 'package:flutter/material.dart';
import 'package:soft_scanner/screens/add_to_bag_screen.dart';

class FloatButtonK extends StatelessWidget {
  // Кнопка вхожа в рюкзак
  const FloatButtonK({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddToBagScreen()));
      },
    );
  }
}
