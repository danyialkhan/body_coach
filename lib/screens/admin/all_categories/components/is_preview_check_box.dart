import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

class IsPreviewChkBox extends StatelessWidget {
  final bool value;
  final Function onChanged;
  IsPreviewChkBox({this.value, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: MediaQuery.of(context).size.width * 0.4),
      child: CheckboxListTile(
        activeColor: purpleShad,
        title: Text(
          'Is Preview',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: purpleShad,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
