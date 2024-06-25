import 'package:flutter/material.dart';
class uihelper extends StatelessWidget {
  uihelper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Widget optionContainer(Widget child) {
    return Container(
      height: 30,
      width: 30,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }

  
}
