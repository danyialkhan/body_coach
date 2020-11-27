import 'package:body_coach/models/subscribers.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
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
              return Container(child: ListView.builder(
                itemCount: subs.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Image(
                          image: subs[index].subscribedName == null
                              ? AssetImage('assets/user.png')
                              : NetworkImage(subs[index].subscribedImgUrl),
                        ),
                      ),
                      title: Text(subs[index].subName),
                      subtitle: Text(subs[index].subscribedName),
                    ),
                  );
                },
              ));
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
