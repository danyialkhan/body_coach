import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return   Container(
      margin: EdgeInsets.only(top: 35.0),
      padding:
      EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
      height: 60.0,
      decoration: BoxDecoration(
          color: whiteShad,
          borderRadius: BorderRadius.circular(30.0)),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 30.0,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5.0),
            width: MediaQuery.of(context).size.width - 110,
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: kSearch,
                  hintStyle: TextStyle(fontSize: 18.0)),
            ),
          )
        ],
      ),
    );
  }
}
