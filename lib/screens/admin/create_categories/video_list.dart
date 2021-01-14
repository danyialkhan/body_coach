import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/screens/admin/all_categories/components/edit_video.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoList extends StatelessWidget {
  final bool enableEdit;
  final String catId;
  final String uId;
  VideoList({
    this.enableEdit = false,
    this.uId,
    this.catId,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<AllVideos>(
      builder: (_, videos, __) {
        if (videos != null && videos?.videos != null) {
          print(videos.videos.length);
          return Container(
            height: videos.videos.length == 0
                ? 0
                : MediaQuery.of(context).size.height * 0.15 +
                    videos.videos.length,
            width: MediaQuery.of(context).size.width * 0.88,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Card(
                    elevation: 5.0,
                    child: ListTile(
                      title: Text(
                        videos.videos[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: purpleShad,
                        ),
                      ),
                      trailing: enableEdit
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.greenAccent,
                                    size: 25.0,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => EditVideo(
                                        vidId: videos.videos[index].id,
                                        catId: catId,
                                        uId: uId,
                                        sec: videos.videos[index].sec,
                                        min: videos.videos[index].min,
                                        link: videos.videos[index].link,
                                        hr: videos.videos[index].hr,
                                        title: videos.videos[index].title,
                                        isPreview: videos.videos[index].isPreview,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 25.0,
                                  ),
                                  onPressed: () async {
                                    await CategoryService(
                                            catId: catId,
                                            uId: uId,
                                            vidId: videos.videos[index].id)
                                        .deleteVideo();
                                  },
                                ),
                              ],
                            )
                          : Text(
                              '${videos.videos[index].hr}hr :${videos.videos[index].min}min :${videos.videos[index].sec}sec',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontStyle: FontStyle.italic,
                                color: purpleShad,
                              ),
                            ),
                    ),
                  ),
                );
              },
              itemCount: videos.videos.length,
            ),
          );
        } else {
          return Text('');
        }
      },
    );
  }
}
