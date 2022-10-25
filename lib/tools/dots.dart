import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  const DotWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
      height: 4,
      width: 4,
    );
  }
}
