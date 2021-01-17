import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/subscribers.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/home/components/my_library/lib_card.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeeAllLib extends StatelessWidget {
  final String title;
  final String userName;
  final String imgUrl;
  SeeAllLib({
    this.title,
    this.imgUrl,
    this.userName,
  });
  @override
  Widget build(BuildContext context) {
    var _mq = MediaQuery.of(context).size;
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: StreamBuilder<List<Subscribers>>(
          stream: UserService(uId: user.uId).userAllLibraryStream(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<Subscribers> models = snapshot.data;
              return ListView.builder(
                shrinkWrap: false,
                itemCount: models.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    width: _mq.width * 0.9,
                    child: FutureBuilder<CategoryModel>(
                      future: CategoryService(catId: models[i].subCat)
                          .getCategory(),
                      builder: (ctx, cat) {
                        if (cat.hasData) {
                          CategoryModel categoryModel = cat.data;
                          return LibCard(
                            categoryModel: categoryModel,
                            userName: userName,
                            imgUrl: imgUrl,
                          );
                        } else {
                          return Container(
                            width: _mq.width * 0.4,
                            height: _mq.height * 0.1,
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: whiteShad,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
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
