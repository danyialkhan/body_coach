import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/home/components/featured/featured_card.dart';
import 'package:body_coach/screens/home/views/workout_view.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeaturedList extends StatelessWidget {
  final String userName;
  final String usrImg;
  FeaturedList({this.userName, this.usrImg,});
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var user = Provider.of<User>(context);
    return StreamBuilder<List<CategoryModel>>(
      stream: CategoryService(uId: user?.uId ?? '').topFiveFeaturedCategoriesStream(),
      builder: (ctx, snapshot){
        if(snapshot.hasData) {
          var models = snapshot.data;
          return Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                  height: mq.height * 0.77,
                  width: mq.width,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: models.length,
                    itemBuilder: (ctx, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => WorkOutView(
                                title: models[i].title,
                                imageUrl: models[i].imgUrl,
                                userName: userName,
                                ownerId: models[i].ownerId,
                                userImage: usrImg,
                                catId: models[i].catId,
                                desc: models[i].description,
                              ),
                            ),
                          );
                        },
                        child: FeaturedCard(
                          title: models[i].title ?? '',
                          category: models[i].title,
                          imageUrl: models[i].imgUrl ?? '',
                          ownerId: models[i].ownerId ?? '',
                          catId: models[i].catId ?? '',
                          userName: userName ?? '',
                          userImg: usrImg ?? '',
                          desc: models[i].description,
                          // level: 'medium',
                          // students: '20k',
                          // star: '5k',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }else{
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: purpleShad,
            ),
          );
        }
      },
    );
  }
}
