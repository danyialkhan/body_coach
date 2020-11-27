import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

class CatField extends StatelessWidget {
  final String title;
  final Function onSaved;
  final Function onChanged;
  final Function onValidate;
  final String hint;
  final TextEditingController controller;

  CatField({
    this.onSaved,
    this.onValidate,
    this.title,
    this.hint,
    this.controller,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, top: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: purpleShad,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: purpleShad),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: TextFormField(
              controller: controller,
              validator: onValidate,
              onSaved: onSaved,
              onChanged: onChanged,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}