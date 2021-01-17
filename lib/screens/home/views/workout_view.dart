import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/data/course.dart';
import 'package:body_coach/models/data/fitness_app_data.dart';
import 'package:body_coach/models/request.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/home/components/youtube_player.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/services/request_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkOutView extends StatefulWidget {
  final data;
  final String title;
  final String level;
  final String equipment;
  final String duration;
  final String stars;
  final List<CourseContent> courseContent;
  final List<WorkOutContent> workoutContent;
  final String imageUrl;
  final String totalSubscription;
  final String image;
  final String catId;
  final String userName;
  final String ownerId;
  final String userImage;
  final String desc;
  WorkOutView({
    this.data,
    this.courseContent,
    this.totalSubscription,
    this.stars,
    this.title,
    this.level,
    this.imageUrl,
    this.equipment,
    this.duration,
    this.image,
    this.workoutContent,
    this.catId,
    this.userName,
    this.ownerId,
    this.userImage,
    this.desc,
  });

  @override
  _WorkOutViewState createState() => _WorkOutViewState();
}

class _WorkOutViewState extends State<WorkOutView> {
  bool _fetchingSubscription = false;

  _toggleSubscription() {
    setState(() {
      _fetchingSubscription = !_fetchingSubscription;
    });
  }

  String _getTextString(int num) {
    if (num < 10) {
      return '0${num + 1}';
    } else {
      return '${num + 1}';
    }
  }

  Widget _courseContentList(Video video, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _getTextString(index),
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE4E7F4),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${video.hr}hr : ${video.min}min : ${video.sec}sec',
                    style: TextStyle(
                      color: Color(0xFFA0A5BD),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    video.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => YoutubeVideoPlayer(
                  videoLink: video.link,
                  title: video.title,
                ),
              ),
            ),
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
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

  Color _getButtonColor(int status) {
    switch (status) {
      case 0:
        return Colors.lime;
      case 1:
        return Colors.greenAccent;
      case 2:
        return Colors.redAccent;
      case 3:
        return Color(0xFF6E8AFA);
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Course App",
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          height: 80.0,
          child: Row(
            children: <Widget>[
              Container(
                height: 60.0,
                width: 70.0,
                decoration: BoxDecoration(
                  color: Color(0xFFFFEDEE),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Icon(
                  Icons.favorite_border,
                  color: Color(0xFFFF6670),
                ),
              ),
              SizedBox(width: 10.0),
              _fetchingSubscription
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: purpleShad,
                      ),
                    )
                  : StreamBuilder<Request>(
                      stream: RequestService(
                        catId: widget.catId,
                        reqId: user.uId,
                      ).requestStatusStream(),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          Request request = snapshot.data;
                          return GestureDetector(
                            onTap: request.reqStatus < 3
                                ? null
                                : () async {
                                    if (request.reqStatus == 3) {
                                      _toggleSubscription();
                                      await RequestService(
                                        sender: user.uId,
                                        receiver: widget.ownerId,
                                        reqId: user.uId,
                                        catId: widget.catId,
                                      ).createRequest(
                                        name: widget.userName,
                                        senderImg: widget.userImage,
                                        trainerImg: widget.imageUrl,
                                        trainer: widget.title,
                                      );
                                      _toggleSubscription();
                                    }
                                  },
                            child: Container(
                              height: 60.0,
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: Color(0xFF6E8AFA),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Center(
                                child: Text(
                                  _getButtonStatus(request.reqStatus ?? 3),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
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
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 400.0,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    top: -56.0,
                    child: Image(
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 400.0,
                      image: widget.imageUrl == null
                          ? AssetImage('assets/icons/BodyCo_Logo2_Charcoal.png')
                          : CachedNetworkImageProvider(widget?.imageUrl),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.black45
                            ),
                            child: Text(
                              widget.title ?? '',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    top: -95,
                    child: Container(
                      height: MediaQuery.of(context).size.height - 400,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                        ),
                      ),
                      child: StreamBuilder<Request>(
                        stream: RequestService(
                          catId: widget.catId,
                          reqId: user.uId,
                        ).requestStatusStream(),
                        builder: (ctx, reqSnapshot) {
                          if (reqSnapshot.hasData) {
                            Request req = reqSnapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.0, right: 20.0, left: 20.0),
                                  child: Text(
                                    "Description: ",
                                    style: TextStyle(
                                      fontSize: 21.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: whiteShad),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(widget.desc),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 15.0,
                                      right: 20.0,
                                      bottom: 20.0,
                                      left: 20.0),
                                  child: Text(
                                    "Workout Videos",
                                    style: TextStyle(
                                      fontSize: 21.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                StreamBuilder<List<Video>>(
                                  stream: (req?.reqStatus ?? 0) == 1
                                      ? CategoryService(catId: widget.catId)
                                          .allVideosStream()
                                      : CategoryService(catId: widget.catId)
                                          .previewVideosStream(),
                                  builder: (ctx, snapshot) {
                                    if (snapshot.hasData) {
                                      List<Video> videos = snapshot.data;
                                      return Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 100.0),
                                          child: ListView.builder(
                                            itemCount: videos?.length ?? 0,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return _courseContentList(
                                                videos[index],
                                                index,
                                              );
                                            },
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
                              ],
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
