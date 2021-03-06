import 'package:body_coach/models/user.dart';
import 'package:body_coach/models/user_profile.dart';
import 'package:body_coach/screens/admin/options_screen.dart';
import 'package:body_coach/screens/authentication/landing/landing_screen.dart';
import 'package:body_coach/screens/profile/profile_screen.dart';
import 'package:body_coach/screens/subscribetion_view/all_subscribers.dart';
import 'package:body_coach/screens/subscribetion_view/all_subscribtions.dart';
import 'package:body_coach/services/auth.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  //static const routeName = '/routeName'; //for navigation route
  //bool isTapped = false;
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  UserProfile _userProfile;
  bool _showAdmin = false;
  bool _isLoading = false;

  @override
  void initState() {
    var user = Provider.of<User>(context, listen: false);
    _getUserData(user.uId);
    super.initState();
  }

  _getUserData(String uid) async {
    _toggleIsLoading();
    _userProfile = await UserService(uId: uid).getUser();
    if (_userProfile?.isAdmin ?? false)
      _showAdmin = true;
    else
      _showAdmin = false;
    _toggleIsLoading();
  }

  _toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<User>(context);
    var _mq = MediaQuery.of(context).size;
    return DrawerHeader(
      child: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
//      mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 1,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: _userProfile?.imgUrl == null
                        ? AssetImage('assets/user.png')
                        : CachedNetworkImageProvider(_userProfile?.imgUrl),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  _userProfile?.name ?? 'User',
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    color: blackShad,
                  ),
                ),
              )
            ],
          ),
          Divider(),
          ListTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ProfileScreen(
                  uid: profile.uId,
                ),
              ),
            ),
            title: Text(
              'My Profile',
              style: TextStyle(color: blackShad),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AllSubscriptions(
                    userProfile: _userProfile,
                  ),
                ),
              );
            },
            title: Text(
              'My Subscriptions',
              style: TextStyle(color: blackShad),
            ),
          ),
          Divider(),
          !_showAdmin
              ? Text('')
              : ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => SubscribersScreen(),
                      ),
                    );
                  },
                  title: Text(
                    'All Subscribers',
                    style: TextStyle(color: blackShad),
                  ),
                ),
          !_showAdmin ? Text('') : Divider(),
          ListTile(
            onTap: () async {
              await Auth().logOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LandingScreen(),
                  ),
                  (Route<dynamic> route) => false);
            },
            title: Text(
              'Logout',
              style: TextStyle(
                color: blackShad,
              ),
            ),
          ),
          Divider(),
          //(_userProfile?.isAdmin == null || _userProfile.isAdmin)
          !_showAdmin
              ? Text('')
              : ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => OptionsScreen(),
                      ),
                    );
                  },
                  title: Text(
                    'Admin',
                    style: TextStyle(
                      color: blackShad,
                    ),
                  ),
                ),
          !_showAdmin ? Text('') : Divider(),
          !_showAdmin
              ? Text('')
              : SizedBox(
                  height: _mq.height * 0.12,
                ),
          Center(
            child: Image.asset(
              pLogoCharcoalPath,
              height: 25.0,
              width: _mq.height * 0.25,
            ),
          )
        ],
      ),
    );
  }
}
