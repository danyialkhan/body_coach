import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

class PriceField extends StatelessWidget {
  final Function onSaved;
  final Function onChanged;
  final Function onValidate;
  final TextEditingController controller;

  PriceField({
    this.onSaved,
    this.onValidate,
    this.controller,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Price ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: whiteShad,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(color: whiteShad),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextFormField(
            keyboardType: TextInputType.number,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '\$0.00',
            ),
            onSaved: onSaved,
            onChanged: onChanged,
            validator: onValidate,
            controller: controller,
          ),
        ),
      ],
    );
  }
}
