import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/home/components/category_card/cat_list_tile.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeeAllCat extends StatelessWidget {
  final String title;
  final String userName;
  final String imgUrl;
  SeeAllCat({
    this.title,
    this.userName,
    this.imgUrl,
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
        child: StreamBuilder<List<CategoryModel>>(
          stream: CategoryService(uId: user.uId).allCategoriesStream(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<CategoryModel> models = snapshot.data;
              return ListView.builder(
                shrinkWrap: false,
                itemCount: models.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    width: _mq.width * 0.9,
                    child: CatListTile(
                      imgUrl: imgUrl,
                      userName: userName,
                      uId: user.uId,
                      model: models[i],
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
