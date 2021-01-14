import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/request.dart';
import 'package:body_coach/models/user_profile.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/services/request_service.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AllReqTabBar extends StatefulWidget {
  final String catId;
  AllReqTabBar({this.catId});

  @override
  _AllReqTabBarState createState() => _AllReqTabBarState();
}

class _AllReqTabBarState extends State<AllReqTabBar> {
  bool _isLoading = false;

  _toggleSubscription() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<Request>>(
        stream: RequestService(catId: widget.catId).requestsStream(),
        builder: (cts, snapshot) {
          if (snapshot.hasData) {
            List<Request> requests = snapshot.data;
            return requests.isEmpty
                ? Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.scaleDown,
                          image: AssetImage('assets/picture.png'),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      return StreamBuilder<UserProfile>(
                        stream: UserService(uId: requests[index].subId)
                            .getUserStream(),
                        builder: (ctx, snapshot) {
                          UserProfile userProfile = snapshot.data;
                          return Container(
                            margin: EdgeInsets.all(10.0),
                            child: Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.all(10.0),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: userProfile?.imgUrl == null
                                      ? AssetImage('assets/user.png')
                                      : CachedNetworkImageProvider(
                                          requests[index].subImgUrl,
                                        ),
                                ),
                                title: Text('${userProfile?.name ?? 'User'}'),
                                subtitle: Text(
                                  'want to join ${requests[index].subscribedName}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                      ),
                                      onPressed: () async {
                                        try {
                                          _toggleSubscription();
                                          CategoryModel model =
                                              await CategoryService(
                                            catId: widget.catId,
                                          ).getCategory();

                                          await RequestService(
                                            reqId: requests[index].subId,
                                            catId: widget.catId,
                                          )
                                              .updateRequestStatus(
                                            status: SubscriptionRequestStatus
                                                .ACCEPTED,
                                          );

                                          List<dynamic> students =
                                              await CategoryService(
                                            uId: requests[index].subId,
                                            catId: widget.catId,
                                          ).addSubscriber(
                                            name: requests[index].subName,
                                            subscribed:
                                                requests[index].subscribedName,
                                            subscribedImg: requests[index]
                                                .subscribedImgUrl,
                                            subImg: requests[index].subImgUrl,
                                          );
                                          await UserService(
                                            uId: model.ownerId,
                                          ).addMyStudent(
                                            id: requests[index].subId,
                                            name: requests[index].subName,
                                            subscribed:
                                                requests[index].subscribedName,
                                            subImg: requests[index].subName,
                                            subscribedImg: requests[index]
                                                .subscribedImgUrl,
                                            catId: widget.catId,
                                            students: students,
                                            catName:
                                                requests[index].subscribedName,
                                          );
                                          await UserService(
                                            uId: requests[index].subId,
                                          ).addSubscribedCategory(
                                            id: widget.catId,
                                            name: requests[index].subName,
                                            subscribed:
                                                requests[index].subscribedName,
                                            subImg: requests[index].subName,
                                            subscribedImg: requests[index]
                                                .subscribedImgUrl,
                                            catId: widget.catId,
                                          );

                                          _toggleSubscription();
                                        } catch (e) {
                                          _toggleSubscription();
                                          print(e);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () async {
                                        await RequestService(
                                          reqId: userProfile?.uId,
                                          catId: widget.catId,
                                        ).removeRequest();

                                        /// Execute below logic only when
                                        /// user wants to quit after joining
                                        /// or if user is removed from subscription
                                        // await CategoryService(
                                        // uId: user.uId, catId: widget.catId)
                                        //     .removeSubscriber();
                                        // await UserService(uId: user.uId)
                                        //     .removeSubscribedCategory(
                                        // id: widget.catId,
                                        // );
                                        // await UserService(uId: widget.ownerId)
                                        //     .removeMyStudent(
                                        // id: user.uId, catId: widget.catId);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    itemCount: requests?.length ?? 0,
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xFF6E8AFA),
              ),
            );
          }
        },
      ),
    );
  }
}
