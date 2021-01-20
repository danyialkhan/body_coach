import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

class SeeAll extends StatelessWidget {
  final String title;
  final Function onTap;

  SeeAll({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: whiteShad
            ),
          ),
          FlatButton(
            onPressed: onTap,
            child: Text(
              kSeeAll,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: lightBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
