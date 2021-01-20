import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

class DurationField extends StatelessWidget {
  final Function onHourSaved;
  final Function onMinSaved;
  final Function onSecSaved;
  final TextEditingController hrController;
  final TextEditingController minController;
  final TextEditingController secController;

  DurationField({
    this.onSecSaved,
    this.onMinSaved,
    this.onHourSaved,
    this.hrController,
    this.minController,
    this.secController,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Text(
            'Duration: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: whiteShad,
            ),
          ),
          Container(
            width: 35.0,
            height: 35.0,
            decoration: BoxDecoration(
                border: Border.all(color: whiteShad),
                borderRadius: BorderRadius.circular(5.0)),
            child: TextFormField(
              onSaved: onHourSaved,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'error';
                }
                return null;
              },
              controller: hrController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '00',
              ),
            ),
          ),
          Text(
            'hr : ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: whiteShad,
            ),
          ),
          Container(
            width: 35.0,
            height: 35.0,
            decoration: BoxDecoration(
                border: Border.all(color: whiteShad),
                borderRadius: BorderRadius.circular(5.0)),
            child: TextFormField(
              onSaved: onMinSaved,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'error';
                }
                return null;
              },
              controller: minController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '00',
              ),
            ),
          ),
          Text(
            'min : ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: whiteShad,
            ),
          ),
          Container(
            width: 35.0,
            height: 35.0,
            decoration: BoxDecoration(
                border: Border.all(color: whiteShad),
                borderRadius: BorderRadius.circular(5.0)),
            child: TextFormField(
              onSaved: onSecSaved,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'error';
                }
                return null;
              },
              controller: secController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '00',
              ),
            ),
          ),
          Text(
            'sec',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: whiteShad,
            ),
          ),
        ],
      ),
    );
  }
}
