import 'package:body_coach/models/subscribers.dart';
import 'package:body_coach/models/user.dart';
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
                    return Card(
                      child: ListTile(
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
                        title: GestureDetector(
                          onTap: () {
                            print('GO TO Workout page....');
                          },
                          child: Text(
                            subs[index].subscribedName,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
