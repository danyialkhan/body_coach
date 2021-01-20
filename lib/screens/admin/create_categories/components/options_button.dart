import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String title;
  final Function onTap;
  OptionButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Card(
      color: lightBlue,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Container(
            margin: EdgeInsets.all(mq.width * 0.1),
            child: Text(
             title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: whiteShad,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
