import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/home/views/workout_view.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:provider/provider.dart';

class SeeAllFet extends StatelessWidget {
  final String title;
  final String userName;
  final String imgUrl;
  SeeAllFet({this.title, this.userName, this.imgUrl,});
  @override
  Widget build(BuildContext context) {
    var _mq = MediaQuery.of(context).size;
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: StreamBuilder< List<CategoryModel>>(
          stream: CategoryService(uId: user.uId).allFeaturedCategoriesStream(),
          builder: (ctx, snapshot) {
            if(snapshot.hasData) {
              List<CategoryModel> models = snapshot.data;
              return ListView.builder(
                shrinkWrap: false,
                itemCount: models.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    width: _mq.width * 0.9,
                    child: GFListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => WorkOutView(
                              title: models[i].title,
                              imageUrl: models[i].imgUrl,
                              catId: models[i].catId,
                              ownerId: models[i].ownerId,
                              userName: userName,
                              userImage: imgUrl,
                              desc: models[i].description,
                            ),
                          ),
                        );
                      },
                      titleText: models[i].title,
                      subtitle: Text(models[i].description),
                      color: whiteShad,
                      avatar: GFImageOverlay(
                        width: _mq.width * 0.2,
                        height: _mq.width * 0.2,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                        boxFit: BoxFit.fill,
                        image: models[i].imgUrl == null
                            ? AssetImage('assets/picture.png')
                            : CachedNetworkImageProvider(models[i].imgUrl),
                      ),
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
      ),
    );
  }
}
