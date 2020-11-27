import 'package:body_coach/shared/constants.dart';
import 'package:body_coach/shared/moods.dart';
import 'package:body_coach/shared/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Positioned moodsHolder(BuildContext context) {
  return Positioned(
    bottom: -45,
    child: Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width - 40,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5.5,
            blurRadius: 5.5,
          )
        ],
      ),
      child: MoodsSelector(),
    ),
  );
}

Container backBgCover() {
  return Container(
    height: 260.0,
    decoration: BoxDecoration(
      gradient: purpleGradient,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
    ),
  );
}

Positioned greetings(BuildContext context) {
  return Positioned(
    left: 20,
    bottom: 90,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hi Dan',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              kHowUFeel,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: CircleAvatar(
            backgroundImage:
            AssetImage(pIconCharcoal),
            radius: 35.0,
          ),
        ),
      ],
    ),
  );
}