import 'package:body_coach/models/user.dart';
import 'package:body_coach/models/user_profile.dart';
import 'package:body_coach/screens/home/components/category_card/category_list.dart';
import 'package:body_coach/screens/home/components/featured/featured_list.dart';
import 'package:body_coach/screens/home/components/title_see_all_strap.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:body_coach/shared/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    _getUserProfile(user.uId);
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
          icon: Icon(Icons.sort),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 10.0),
            child: Image(
              height: 40.0,
              width: 40.0,
              image: (_userProfile == null || _userProfile?.imgUrl == null)
                  ? AssetImage('assets/user.png')
                  : NetworkImage(_userProfile.imgUrl),
            ),
          )
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: _isLoading ?
              Center(
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
                _isLoading ? "Hey ...," : 'Hey ${_userProfile.name}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
              ),
              SizedBox(height: 15.0),
              Text(
                kHomeDescription,
                style: TextStyle(fontSize: 22.0, color: purpleShad),
              ),
              Container(
                margin: EdgeInsets.only(top: 35.0),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                height: 60.0,
                decoration: BoxDecoration(
                    color: whiteShad,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        size: 30.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      width: MediaQuery.of(context).size.width - 110,
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: kSearch,
                            hintStyle: TextStyle(fontSize: 18.0)),
                      ),
                    )
                  ],
                ),
              ),
              SeeAll(
                onTap: () => print('See All Categories'),
                title: kCat,
              ),
              CategoryList(
                userName: _userProfile.name,
                imgUrl: _userProfile.imgUrl,
              ),
              SeeAll(
                onTap: () => print('See All Featured'),
                title: kFet,
              ),
              FeaturedList(
                userName: _userProfile.name,
                usrImg: _userProfile.imgUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
