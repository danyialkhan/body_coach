import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/screens/subscribetion_view/category_detail.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/services/request_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class SubCard extends StatefulWidget {
  final CategoryModel model;

  SubCard({this.model});

  @override
  _SubCardState createState() => _SubCardState();
}

String _getTextForSubs(int val) {
  if (val <= 1)
    return '$val student have joined this course.';
  else
    return '$val students have joined this course.';
}

String _getTextForRequests(int val) {
  if (val <= 1)
    return 'You have $val request pending.';
  else
    return 'You have $val requests pending.';
}

class _SubCardState extends State<SubCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: GFCard(
          boxFit: BoxFit.cover,
          image: widget.model.imgUrl == null
              ? Image.asset('assets/images/work1.png')
              : Image(
                  image: CachedNetworkImageProvider(widget.model.imgUrl),
                ),
          title: GFListTile(
            title: Text(widget.model.title),
          ),
          content: Column(
            children: <Widget>[
              StreamBuilder<int>(
                stream:
                    CategoryService(catId: widget.model.catId).studentCount(),
                builder: (ctx, snapshot) {
                  return Text(
                    _getTextForSubs(
                      snapshot.data == null ? 0 : snapshot.data,
                    ),
                  );
                },
              ),
              StreamBuilder<int>(
                stream:
                    RequestService(catId: widget.model.catId).countRequests(),
                builder: (ctx, snapshot) {
                  return Text(
                    _getTextForRequests(
                      snapshot.data == null ? 0 : snapshot.data,
                    ),
                  );
                },
              )
            ],
          ),
          buttonBar: GFButtonBar(
            children: <Widget>[
              GFButton(
                color: whiteShad,
                textColor: purpleShad2,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => CategoryDetail(
                        title: widget.model.title,
                        cId: widget.model.catId,
                        cImg: widget.model.imgUrl,
                      ),
                    ),
                  );
                },
                text: 'details',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
