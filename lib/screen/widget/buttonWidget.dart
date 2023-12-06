import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  // const ButtonWidget({super.key});
  final String title;
  final bool hasBorder;
  ButtonWidget({required this.title, required this.hasBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: hasBorder ? Colors.white : Colors.lightBlue,
          borderRadius: BorderRadius.circular(10),
          border: hasBorder
              ? Border.all(color: Colors.lightBlue)
              : Border.fromBorderSide(BorderSide.none)),
      height: 50,
      width: double.infinity,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: hasBorder ? Colors.lightBlue : Colors.white,
          ),
        ),
      ),
    );
  }
}
