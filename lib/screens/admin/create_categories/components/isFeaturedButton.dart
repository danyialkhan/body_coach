import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

class IsFeaturedButton extends StatelessWidget {
  final List<String> subscriptions;
  final String selectionSubscription;
  final Function onChanged;
  final Function onValidate;

  IsFeaturedButton({
    this.selectionSubscription,
    this.subscriptions,
    this.onChanged,
    this.onValidate,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Is Featured ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: whiteShad,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.55,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: whiteShad),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: DropdownButtonFormField(
              hint: Text('Featured'),
              validator: onValidate,
              value: selectionSubscription,
              onChanged: onChanged,
              items: subscriptions.map((e) {
                return DropdownMenuItem(
                  child: Text(e),
                  value: e,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
