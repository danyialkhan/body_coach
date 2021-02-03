import 'package:body_coach/models/user.dart';
import 'package:body_coach/models/user_profile.dart';
import 'package:body_coach/screens/home/components/category_card/category_list.dart';
import 'package:body_coach/screens/home/components/category_card/see_all_cat.dart';
import 'package:body_coach/screens/home/components/featured/featured_list.dart';
import 'package:body_coach/screens/home/components/featured/see_all_fet.dart';
import 'package:body_coach/screens/home/components/my_library/my_library_list.dart';
import 'package:body_coach/screens/home/components/my_library/see_all_lib.dart';
import 'package:body_coach/screens/home/components/title_see_all_strap.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:body_coach/shared/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/search/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfile _userProfile;
  bool _isLoading = false;

  @override
  void initState() {
    var user = Provider.of<User>(context, listen: false);
    _getUserProfile(user?.uId ?? '');
    super.initState();
  }

  _toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  _getUserProfile(String uid) async {
    _toggleIsLoading();
    _userProfile = await UserService(uId: uid).getUser();
    _toggleIsLoading();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _drawerKey = new GlobalKey();
    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: CustomDrawer(),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _drawerKey.currentState.openDrawer();
          },
          icon: Icon(
            Icons.sort,
            color: whiteShad,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: purpleShad,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      _isLoading ? "Hey ...," : 'Hey ${_userProfile?.name},',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        color: whiteShad,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      kHomeDescription,
                      style: TextStyle(
                        fontSize: 22.0,
                        color: greyShad,
                      ),
                    ),
                    // Search(),
                    SeeAll(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => SeeAllLib(
                              title: kMyLib,
                            ),
                          ),
                        );
                      },
                      title: kMyLib,
                    ),
                    MyLibraryList(
                      userName: _userProfile?.name,
                      imgUrl: _userProfile?.imgUrl,
                    ),
                    SeeAll(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => SeeAllCat(
                              title: kCat,
                              userName: _userProfile?.name,
                              imgUrl: _userProfile?.imgUrl,
                            ),
                          ),
                        );
                      },
                      title: kCat,
                    ),
                    CategoryList(
                      userName: _userProfile?.name,
                      imgUrl: _userProfile?.imgUrl,
                    ),
                    SeeAll(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => SeeAllFet(
                              title: kFet,
                              userName: _userProfile?.name,
                              imgUrl: _userProfile?.imgUrl,
                            ),
                          ),
                        );
                      },
                      title: kFet,
                    ),
                    FeaturedList(
                      userName: _userProfile?.name,
                      usrImg: _userProfile?.imgUrl,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
