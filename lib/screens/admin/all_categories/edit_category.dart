import 'dart:io';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/admin/create_categories/add_videos.dart';
import 'package:body_coach/screens/admin/create_categories/components/cat_fielt.dart';
import 'package:body_coach/screens/admin/create_categories/components/description_field.dart';
import 'package:body_coach/screens/admin/create_categories/components/image_selector.dart';
import 'package:body_coach/screens/admin/create_categories/components/isFeaturedButton.dart';
import 'package:body_coach/screens/admin/create_categories/components/price_field.dart';
import 'package:body_coach/screens/admin/create_categories/components/subs_button.dart';
import 'package:body_coach/screens/admin/create_categories/video_list.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:body_coach/shared/image_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditCategory extends StatefulWidget {
  final String catId;
  final String currentTitle;
  final int currentSub;
  final String currentPrice;
  final String imgLink;
  final bool featured;
  final String description;
  final Timestamp creationTime;

  EditCategory({
    this.currentPrice,
    this.currentSub,
    this.currentTitle,
    this.imgLink,
    this.catId,
    this.featured,
    this.description,
    this.creationTime,
  });

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  bool _isLoading = false;
  bool _isLink = true;
  File _image;
  String _title;
  int _type;
  String _price;
  String _description;
  final picker = ImagePicker();
  String _selectionSubscription;
  String _selectionFeatured;
  bool _featured;
  List<String> _subscription = [
    'Paid',
    'Unpaid',
  ]; // Option 2
  List<String> _isFeatured = [
    'Yes',
    'No',
  ];
  bool _showPrice = false;

  @override
  void initState() {
    nameController.text = widget.currentTitle;
    priceController.text = widget.currentPrice;
    descController.text = widget.description;
    if (widget.currentSub == 0) {
      _type = 0;
      _showPrice = true;
      _selectionSubscription = 'Paid';
    }
    if (widget.currentSub == 1) {
      _type = 1;
      _selectionSubscription = 'Unpaid';
    }

    if (widget?.featured != null && (widget?.featured ?? false)) {
      _selectionFeatured = 'Yes';
    } else {
      _selectionFeatured = 'No';
    }

    super.initState();
  } // launch image picker

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _isLink = false;
      } else {
        print('No image selected.');
      }
    });
  }

  _toggleIsLoading() {
    if (!mounted) return;
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
        title: Text('Edit Course'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  _isLoading
                      ? LinearProgressIndicator(
                          backgroundColor: kPrimaryColor,
                        )
                      : Text(''),
                  ImageSelector(
                    getImage: getImage,
                    image: _image,
                    isLink: _isLink,
                    imgLink: widget.imgLink,
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
                    controller: nameController,
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
                    controller: descController,
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
                          controller: priceController,
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
                  AddVideoLink(
                    addToCollection: true,
                    catId: widget.catId,
                    uId: user.uId,
                  ),
                  VideoList(
                    enableEdit: true,
                    catId: widget.catId,
                    uId: user.uId,
                  ),
                  FlatButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            String url;
                            try {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                _toggleIsLoading();
                                if (_image != null) {
                                  url = await ImageFunctions.uploadSentImage(
                                      _image, 'Categories/${user.uId}');
                                }
                                await CategoryService(
                                        uId: user.uId, catId: widget.catId)
                                    .updateCategory(
                                  title: _title,
                                  price: _price,
                                  type: _type,
                                  imgUrl: url ?? widget.imgLink,
                                  featured: _featured,
                                  desc: _description,
                                  creationTIme: widget.creationTime,
                                );
                                _toggleIsLoading();
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
