import 'package:flutter/material.dart';

import 'constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double scale;
  const TextFieldContainer({
    Key key,
    this.child,
    this.scale = 0.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * scale,
      decoration: BoxDecoration(
        color: whiteShad,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
