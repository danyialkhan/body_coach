import 'dart:io';
import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/admin/create_categories/components/description_field.dart';
import 'package:body_coach/screens/admin/create_categories/components/isFeaturedButton.dart';
import 'package:body_coach/screens/admin/create_categories/video_list.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:body_coach/shared/image_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'add_videos.dart';
import 'components/cat_fielt.dart';
import 'components/image_selector.dart';
import 'components/price_field.dart';
import 'components/subs_button.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  File _image;
  String _title;
  int _type;
  String _price;
  bool _isLoading = false;
  final picker = ImagePicker();
  String _selectionSubscription;
  String _selectionFeatured;
  String _description;
  bool _featured;
  bool _isRun = false;
  List<String> _subscription = [
    'Paid',
    'Unpaid',
  ];
  List<String> _isFeatured = [
    'Yes',
    'No',
  ]; // Option 2
  bool _showPrice = false;
  // launch image picker
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isRun) {
      Provider.of<AllVideos>(context, listen: false).clear();
      _isRun = false;
    }
    super.didChangeDependencies();
  }

  _toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final GlobalKey<FormState> _formKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _isLoading
                    ? LinearProgressIndicator(
                        backgroundColor: kPrimaryColor,
                      )
                    : Text(''),
                ImageSelector(
                  getImage: getImage,
                  image: _image,
                  isLink: false,
                ),
                SizedBox(
                  height: 10.0,
                ),
                CatField(
                  title: 'Title ',
                  hint: 'title',
                  color: whiteShad,
                  onSaved: (val) {
                    _title = val;
                  },
                  onValidate: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please Enter a valid title..';
                    }
                    return null;
                  },
                ),
                DescriptionField(
                  title: 'Description ',
                  hint: 'description...',
                  color: whiteShad,
                  onSaved: (val) {
                    _description = val;
                  },
                  onValidate: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please Enter a valid description..';
                    }
                    return null;
                  },
                ),
                SubsButton(
                  color: whiteShad,
                  onChanged: (val) {
                    setState(
                      () {
                        _selectionSubscription = val;
                        switch (val) {
                          case 'Paid':
                            _showPrice = true;
                            _type = 0;
                            break;
                          case 'Unpaid':
                            _showPrice = false;
                            _type = 1;
                            break;
                        }
                      },
                    );
                  },
                  onValidate: (val) {
                    if (val == null) return 'Please Select Subscription Type';
                    return null;
                  },
                  selectionSubscription: _selectionSubscription,
                  subscriptions: _subscription,
                ),
                IsFeaturedButton(
                  color: whiteShad,
                  onChanged: (val) {
                    setState(
                      () {
                        _selectionFeatured = val;
                        switch (val) {
                          case 'Yes':
                            _featured = true;
                            break;
                          case 'No':
                            _featured = false;
                            break;
                        }
                      },
                    );
                  },
                  onValidate: (val) {
                    if (val == null) return 'Please Select Featured Type';
                    return null;
                  },
                  selectionSubscription: _selectionFeatured,
                  subscriptions: _isFeatured,
                ),
                _showPrice
                    ? PriceField(
                        color: whiteShad,
                        onSaved: (val) {
                          _price = val;
                          print('PRICE: $_price');
                        },
                        onValidate: (val) {
                          if (val == null || val.isEmpty)
                            return 'Please enter a valid price';
                          return null;
                        },
                      )
                    : Text(''),
                SizedBox(
                  height: 5.0,
                ),
                AddVideoLink(),
                VideoList(),
                FlatButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          try {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (_image != null) {
                                _toggleIsLoading();
                                String url =
                                    await ImageFunctions.uploadSentImage(
                                        _image, 'Categories/${user.uId}');
                                var catId = await CategoryService(uId: user.uId)
                                    .createCategory(
                                  title: _title,
                                  price: _price,
                                  type: _type,
                                  imgUrl: url,
                                  featured: _featured,
                                  desc: _description,
                                );
                                var allVideos = Provider.of<AllVideos>(context,
                                    listen: false);
                                for (var i = 0;
                                    i < allVideos.videos.length;
                                    i++) {
                                  print(
                                      'add video: ${allVideos.videos[i].title}');
                                  print('Cat ID: $catId');
                                  await CategoryService(
                                          catId: catId, uId: user.uId)
                                      .addVideos(
                                    sec: allVideos.videos[i].sec,
                                    min: allVideos.videos[i].min,
                                    link: allVideos.videos[i].link,
                                    hr: allVideos.videos[i].hr,
                                    title: allVideos.videos[i].title,
                                  );
                                }
                                _toggleIsLoading();
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'Image must not be empty...',
                                  backgroundColor: Colors.redAccent,
                                );
                              }
                            }
                          } catch (e) {
                            _toggleIsLoading();
                            print(e);
                          }
                        },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: whiteShad,
                    ),
                  ),
                  color: purpleShad,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
