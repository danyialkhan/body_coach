import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/subscribers.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/home/views/workout_view.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllSubscriptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Subscriptions'),
      ),
      body: Container(
        child: StreamBuilder<List<Subscribers>>(
          stream: UserService(uId: user.uId).getSubscriptions(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              var subs = snapshot.data;
              return Container(
                child: ListView.builder(
                  itemCount: subs.length,
                  itemBuilder: (ctx, index) {
                    return FutureBuilder<CategoryModel>(
                      future: CategoryService(catId: subs[index].subCat).getCategory(),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          var model = snapshot.data;
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => WorkOutView(
                                        title: model.title,
                                        imageUrl: model.imgUrl,
                                        userName: subs[index].subName,
                                        ownerId: model.ownerId,
                                        userImage: subs[index].subImgUrl,
                                        catId: model.catId,
                                        desc: model.description,
                                      ),
                                    )
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image(
                                  image: subs[index].subscribedImgUrl == null
                                      ? AssetImage('assets/user.png')
                                      : CachedNetworkImageProvider(
                                          subs[index].subscribedImgUrl,
                                        ),
                                ),
                              ),
                              title: Text(
                                subs[index].subscribedName,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.height * 0.9,
                            decoration: BoxDecoration(
                              color: whiteShad,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          );
                        }
                      },
                    );
                  },
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
