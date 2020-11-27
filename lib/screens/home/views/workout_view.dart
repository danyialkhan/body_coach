import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/data/course.dart';
import 'package:body_coach/models/data/fitness_app_data.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/home/youtube_player.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
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
  final bool isUrl;
  final String catId;
  final String userName;
  final String ownerId;
  final String userImage;
  WorkOutView(
      {this.data,
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
      this.isUrl = false});

  @override
  _WorkOutViewState createState() => _WorkOutViewState();
}

class _WorkOutViewState extends State<WorkOutView> {
  List<Video> videos = [];
  bool _isLoading = false;
  bool _fetchingSubscription = false;

  @override
  void initState() {
    _getVideos();
    super.initState();
  }

  _toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  _toggleSubscription() {
    setState(() {
      _fetchingSubscription = !_fetchingSubscription;
    });
  }

  _getVideos() async {
    _toggleIsLoading();
    videos = await CategoryService(catId: widget.catId).getVideos();
    _toggleIsLoading();
  }

  Widget _courseContentList(index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "0" + (1 + index).toString(),
            style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE4E7F4)),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${videos[index].hr}hr : ${videos[index].min}min : ${videos[index].sec}sec',
                    style: TextStyle(
                        color: Color(0xFFA0A5BD),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    videos[index].title,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => YoutubeVideoPlayer(
                      videoLink: videos[index].link,
                      title: videos[index].title,
                    ))),
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  color: Color(0xFF49CC96),
                  borderRadius: BorderRadius.circular(20.0)),
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
                    borderRadius: BorderRadius.circular(30.0)),
                child: Icon(
                  Icons.favorite_border,
                  color: Color(0xFFFF6670),
                ),
              ),
              SizedBox(width: 10.0),
              StreamBuilder<bool>(
                stream: UserService(uId: user.uId)
                    .checkSubscribed(catId: widget.catId),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () async {
                        if (!snapshot.data) {
                          await CategoryService(
                                  uId: user.uId, catId: widget.catId)
                              .addSubscriber(
                            name: widget.userName,
                            subscribed: widget.title,
                          );
                          await UserService(uId: widget.ownerId)
                              .addUserSubscriptions(
                            id: user.uId,
                            name: widget.userName,
                            subscribed: widget.title,
                            subImg: widget.userImage,
                            subscribedImg: widget.image,
                          );
                          await UserService(uId: user.uId)
                              .addSubscribedCategory(
                            id: widget.catId,
                            name: widget.title,
                            subscribed: widget.userName,
                            subImg: widget.userImage,
                            subscribedImg: widget.image,
                          );
                        } else {
                          await CategoryService(
                                  uId: user.uId, catId: widget.catId)
                              .removeSubscriber();
                          await UserService(uId: user.uId)
                              .removeSubscribedCategory(
                            id: widget.catId,
                          );
                          await UserService(uId: widget.ownerId)
                              .removeUserSubscriptions(
                            id: user.uId,
                          );
                        }
                      },
                      child: Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: Color(0xFF6E8AFA),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Center(
                          child: Text(
                            !snapshot.data ? "Subscribe" : 'UnSubscribe',
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
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: widget.isUrl ? Colors.white : Colors.black,
            ),
          ),
          // actions: <Widget>[
          //   IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.more_vert),
          //   )
          // ],
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
                      image: NetworkImage(widget.image),
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
                          // Image(
                          //   width: 100.0,
                          //   image: AssetImage("assets/course/bestseller.png"),
                          // ),
                          // SizedBox(
                          //   height: 10.0,
                          // ),
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          // Row(
                          //   children: <Widget>[
                          //     Row(
                          //       children: <Widget>[
                          //         Icon(
                          //           Icons.people,
                          //           color: widget.isUrl
                          //               ? Colors.white
                          //               : Color(0xFF61688B),
                          //         ),
                          //         // SizedBox(width: 5.0),
                          //         // Text(
                          //         //   widget.totalSubscription + "k",
                          //         //   style: TextStyle(
                          //         //       fontWeight: FontWeight.bold,
                          //         //       color: widget.isUrl
                          //         //           ? Colors.white
                          //         //           : Color(0xFF61688B)),
                          //         // )
                          //       ],
                          //     ),
                          //     SizedBox(width: 10.0),
                          //     Row(
                          //       children: <Widget>[
                          //         Icon(
                          //           Icons.star,
                          //           color: widget.isUrl
                          //               ? Colors.white
                          //               : Color(0xFF61688B),
                          //         ),
                          //         SizedBox(width: 5.0),
                          //         // Text(
                          //         //   widget.stars + "k",
                          //         //   style: TextStyle(
                          //         //       fontWeight: FontWeight.bold,
                          //         //       color: widget.isUrl
                          //         //           ? Colors.white
                          //         //           : Color(0xFF61688B)),
                          //         // )
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 20.0,
                          ),
//                          Text(
//                            "\$" + data.price,
//                            style: TextStyle(
//                                fontSize: 25.0, fontWeight: FontWeight.bold),
//                          )
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
                              topRight: Radius.circular(50.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 40.0,
                                right: 20.0,
                                bottom: 20.0,
                                left: 20.0),
                            child: Text(
                              "Workout Videos",
                              style: TextStyle(
                                  fontSize: 21.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: purpleShad,
                                  ),
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 100.0),
                                    child: ListView.builder(
                                        itemCount: videos.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _courseContentList(index);
                                        }),
                                  ),
                                )
                        ],
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
