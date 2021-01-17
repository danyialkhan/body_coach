import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/admin/all_categories/edit_category.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext ctx, {String cId}) {
      print('$cId');
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(ctx).pop();
        },
      );
      Widget continueButton = FlatButton(
        child: Text("Yes"),
        onPressed: () async {
          await CategoryService(catId: cId).deleteCategory();
          Navigator.of(ctx).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(
          "Warning",
          style: TextStyle(color: Colors.redAccent),
        ),
        content: Text("Are you sure you want to delete entire course?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('All Categories'),
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: CategoryService(uId: user.uId).categoriesStream(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            var models = snapshot.data;
            return ListView.builder(
              itemCount: models.length,
              itemBuilder: (ctx, index) {
                return Container(
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.transparent,
                        child: models[index].imgUrl == null
                            ? Container(
                                color: Colors.blueGrey,
                              )
                            : Image(
                                image: CachedNetworkImageProvider(
                                  models[index].imgUrl,
                                ),
                                fit: BoxFit.fill,
                              ),
                      ),
                      title: Text(
                        models[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: purpleShad,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.greenAccent,
                            ),
                            onPressed: () async {
                              var vid = Provider.of<AllVideos>(context,
                                  listen: false);
                              List<Video> videos = await CategoryService(
                                uId: user.uId,
                                catId: models[index].catId,
                              ).getAllVideos();
                              print('LENGTH: ${videos.length}');
                              vid.setVideoList(videos);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => EditCategory(
                                    catId: models[index].catId,
                                    imgLink: models[index].imgUrl,
                                    currentPrice: models[index].price,
                                    currentSub: models[index].subType,
                                    currentTitle: models[index].title,
                                    description: models[index].description,
                                    creationTime: models[index].createdTime,
                                    featured: models[index].isFeatured,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              showAlertDialog(ctx, cId: models[index].catId);
                            },
                          ),
                        ],
                      ),
                    ),
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
    );
  }
}
