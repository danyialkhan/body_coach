import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/home/components/category_card/category_card.dart';
import 'package:body_coach/screens/home/views/workout_view.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  final String userName;
  final String imgUrl;
  CategoryList({this.userName, this.imgUrl,});
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.3,
      child: StreamBuilder< List<CategoryModel>>(
        stream: CategoryService(uId: user.uId).categoriesStream(),
        builder: (ctx, snapshot) {
          if(snapshot.hasData) {
            List<CategoryModel> models = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: models.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, i) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>
                            WorkOutView(
                              title: models[i].title,
                              image: models[i].imgUrl,
                              catId: models[i].catId,
                              ownerId: models[i].ownerId,
                              userName: userName,
                              userImage: imgUrl,
                            ),
                      ),
                    );
                  },
                  child: CategoryCard(
                    course: models[i],
                  ),
                );
              },
            );
          }else{
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
