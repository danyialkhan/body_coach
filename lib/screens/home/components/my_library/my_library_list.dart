import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/subscribers.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/home/components/category_card/category_card.dart';
import 'package:body_coach/screens/home/views/workout_view.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLibraryList extends StatelessWidget {
  final String userName;
  final String imgUrl;
  MyLibraryList({
    this.userName,
    this.imgUrl,
  });
  @override
  Widget build(BuildContext context) {
    var _mq = MediaQuery.of(context).size;
    var user = Provider.of<User>(context);
    return Container(
      child: StreamBuilder<List<Subscribers>>(
        stream: UserService(uId: user?.uId ?? '').userLibraryStream(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            List<Subscribers> models = snapshot.data;
            return models.isEmpty
                ? Center(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: whiteShad, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Subscribe to start your first workout..',
                        style: TextStyle(
                          color: whiteShad,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: models.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        return FutureBuilder<CategoryModel>(
                            future: CategoryService(catId: models[i].subCat)
                                .getCategory(),
                            builder: (ctx, cat) {
                              if (cat.hasData) {
                                CategoryModel categoryModel = cat.data;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => WorkOutView(
                                          title: categoryModel.title,
                                          imageUrl: categoryModel.imgUrl,
                                          catId: categoryModel.catId,
                                          ownerId: categoryModel.ownerId,
                                          userName: userName,
                                          userImage: imgUrl,
                                          desc: categoryModel.description,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CategoryCard(
                                    course: categoryModel,
                                  ),
                                );
                              } else {
                                return Container(
                                  width: _mq.width * 0.4,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: whiteShad,
                                  ),
                                );
                              }
                            });
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
    );
  }
}
