import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/screens/admin/all_categories/components/is_preview_check_box.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/cat_fielt.dart';
import 'components/duration_field.dart';

class AddVideoLink extends StatefulWidget {
  final bool addToCollection;
  final bool updateVideo;
  final String uId;
  final String catId;
  final String hr;
  final String min;
  final String sec;
  final String link;
  final String title;
  final String vidId;
  final bool isPreview;

  AddVideoLink(
      {this.uId,
      this.catId,
      this.title,
      this.hr,
      this.link,
      this.min,
      this.sec,
      this.vidId,
      this.addToCollection = false,
      this.updateVideo = false,
      this.isPreview = false});

  @override
  _AddVideoLinkState createState() => _AddVideoLinkState();
}

class _AddVideoLinkState extends State<AddVideoLink> {
  final _titleController = TextEditingController();
  final _linkController = TextEditingController();
  final _hrController = TextEditingController();
  final _minController = TextEditingController();
  final _secController = TextEditingController();
  String _videoTitle;
  String _videoLink;
  String _hr;
  String _min;
  String _sec;
  bool _isLoading = false;
  bool _isPreview;
  @override
  void initState() {
    if (widget.updateVideo) {
      _titleController.text = widget.title;
      _hrController.text = widget.hr;
      _minController.text = widget.min;
      _secController.text = widget.sec;
      _linkController.text = widget.link;
    }
    super.initState();
  }

  _toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _videoFormKey = GlobalKey();
    return Container(
      margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
      padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 15.0),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Form(
        key: _videoFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CatField(
              controller: _titleController,
              title: 'Video Title ',
              hint: 'Title.',
              onSaved: (val) {
                _videoTitle = val;
              },
              onValidate: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please Enter a valid title..';
                }
                return null;
              },
            ),
            CatField(
              controller: _linkController,
              title: 'Video Link ',
              hint: 'https://-----',
              onSaved: (val) {
                _videoLink = val;
              },
              onValidate: (String val) {
                if (val == null || val.isEmpty) {
                  return 'Link must be provided..';
                }
                if (val.contains(
                    '(\b(https?|ftp|file):\/\/)?[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]')) {
                  return 'Please provide a valid link...';
                }
                return null;
              },
            ),
            DurationField(
              hrController: _hrController,
              minController: _minController,
              secController: _secController,
              onHourSaved: (val) {
                _hr = val;
              },
              onMinSaved: (val) {
                _min = val;
              },
              onSecSaved: (val) {
                _sec = val;
              },
            ),

            IsPreviewChkBox(
              value: _isPreview ?? widget.isPreview ?? false,
              onChanged: (value) {
                  setState(() {
                    _isPreview = value;
                  });
              },
            ),

            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: purpleShad,
                    ),
                  )
                : FlatButton(
                    color: purpleShad,
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: whiteShad,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_videoFormKey.currentState.validate()) {
                              _videoFormKey.currentState.save();
                              var video = Provider.of<AllVideos>(context,
                                  listen: false);
                              Video vid = Video(
                                id: widget.vidId,
                                catId: widget.catId,
                                title: _videoTitle,
                                hr: _hr,
                                link: _videoLink,
                                min: _min,
                                sec: _sec,
                                isPreview: _isPreview ?? widget.isPreview ?? false,
                              );
                              if (!widget.updateVideo) {
                                video.setVideo(vid);
                              }

                              try {
                                if (widget.addToCollection) {
                                  _toggleIsLoading();
                                  await CategoryService(
                                          uId: widget.uId, catId: widget.catId)
                                      .addVideos(
                                    title: _videoTitle,
                                    hr: _hr,
                                    link: _videoLink,
                                    min: _min,
                                    sec: _sec,
                                    isPreview: _isPreview ?? widget.isPreview,
                                  );
                                  _toggleIsLoading();
                                }
                                if (widget.updateVideo) {
                                  _toggleIsLoading();
                                  await CategoryService(
                                    uId: widget.uId,
                                    catId: widget.catId,
                                    vidId: widget.vidId,
                                  ).updateVideos(
                                    title: _videoTitle,
                                    hr: _hr,
                                    link: _videoLink,
                                    min: _min,
                                    sec: _sec,
                                    isPreview: _isPreview ?? widget.isPreview,
                                  );
                                  var videos = video.videos;
                                  videos.removeWhere(
                                      (element) => element.id == widget.vidId);
                                  videos.add(vid);
                                  video.setVideoList(videos);
                                  _toggleIsLoading();
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                _toggleIsLoading();
                                print(e);
                              }
                              _titleController.clear();
                              _linkController.clear();
                              _hrController.clear();
                              _minController.clear();
                              _secController.clear();
                            }
                          },
                  ),
          ],
        ),
      ),
    );
  }
}
