import 'package:body_coach/models/subscribers.dart';
import 'package:body_coach/models/user_profile.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AllSubTabBar extends StatelessWidget {
  final String catId;
  AllSubTabBar({this.catId});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<Subscribers>>(
        stream: CategoryService(catId: catId).getSubscribers(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            List<Subscribers> subscribers = snapshot.data;
            return subscribers.isEmpty
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
                        stream: UserService(uId: subscribers[index].subId)
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
                                    subscribers[index].subImgUrl,
                                  ),
                                ),
                                title: Text('${userProfile?.name ?? 'User'}'),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    itemCount: subscribers?.length ?? 0,
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
