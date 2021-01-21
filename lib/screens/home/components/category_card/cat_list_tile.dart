import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/request.dart';
import 'package:body_coach/screens/home/views/workout_view.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/services/request_service.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class CatListTile extends StatefulWidget {
  final CategoryModel model;
  final String userName;
  final String imgUrl;
  final String uId;
  CatListTile({this.model,this.imgUrl, this.userName,this.uId,});
  @override
  _CatListTileState createState() => _CatListTileState();
}

class _CatListTileState extends State<CatListTile> {

  bool _fetchingSubscription = false;

  _toggleSubscription() {
    setState(() {
      _fetchingSubscription = !_fetchingSubscription;
    });
  }

  String _getButtonStatus(int status) {
    switch (status) {
      case 0:
        return "REQUEST PENDING";
      case 1:
        return "SUBSCRIBED";
      case 2:
        return "REJECTED";
      case 3:
        return "SUBSCRIBE";
      default:
        return "ERROR";
    }
  }

  @override
  Widget build(BuildContext context) {
    var _mq = MediaQuery.of(context).size;
    return GFListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => WorkOutView(
              title: widget.model.title,
              imageUrl: widget.model.imgUrl,
              catId: widget.model.catId,
              ownerId: widget.model.ownerId,
              userName: widget.userName,
              userImage: widget.imgUrl,
              desc: widget.model.description,
            ),
          ),
        );
      },
      titleText: widget.model.title,
      subtitle: Text(widget.model.description),
      color: whiteShad,
      avatar: GFImageOverlay(
        width: _mq.width * 0.2,
        height: _mq.width * 0.2,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        boxFit: BoxFit.fill,
        image: widget.model.imgUrl == null
            ? AssetImage('assets/picture.png')
            : CachedNetworkImageProvider(widget.model.imgUrl),
      ),
      icon: GestureDetector(
        onTap: () {},
        child: _fetchingSubscription
            ? Center(
          child: CircularProgressIndicator(
            backgroundColor: purpleShad,
          ),
        )
            : StreamBuilder<Request>(
          stream: RequestService(
            catId: widget.model.catId,
            reqId: widget.uId,
          ).requestStatusStream(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              Request request = snapshot.data;
              return GestureDetector(
                onTap: () async {
                  _toggleSubscription();
                  if (request.reqStatus == 3) {
                    await RequestService(
                      sender: widget.uId,
                      receiver: widget.model.ownerId,
                      reqId: widget.uId,
                      catId: widget.model.catId,
                    ).createRequest(
                      name: widget.userName,
                      senderImg: widget.imgUrl,
                      trainerImg: widget.model.imgUrl,
                      trainer: widget.model.title,
                    );
                  }
                  else if (request.reqStatus == 1) {
                    await CategoryService(
                        uId: widget.uId, catId: widget.model.catId)
                        .removeSubscriber();
                    await UserService(uId: widget.uId)
                        .removeSubscribedCategory(
                      id: widget.model.catId,
                    );
                    await UserService(uId: widget.model.ownerId)
                        .removeMyStudent(
                        id: widget.uId, catId: widget.model.catId);
                    await RequestService(
                      reqId: widget.uId,
                      catId: widget.model.catId,
                    ).removeRequest();
                  }
                  _toggleSubscription();
                },
                child:Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getButtonStatus(request.reqStatus ?? 3),
                    style: TextStyle(
                      color: whiteShad,
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: purpleShad,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

