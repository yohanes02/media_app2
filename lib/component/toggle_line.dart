import 'package:flutter/material.dart';

class ToggleLine extends StatelessWidget {
  const ToggleLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.green.shade300,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          height: 8.0,
          width: 50,
        ),
      ),
      // color: Colors.white54,
    );
  }
}
