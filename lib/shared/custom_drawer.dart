import 'package:body_coach/models/user.dart';
import 'package:body_coach/models/user_profile.dart';
import 'package:body_coach/screens/admin/options_screen.dart';
import 'package:body_coach/screens/profile/profile_screen.dart';
import 'package:body_coach/screens/subscribetion_view/all_subscribers.dart';
import 'package:body_coach/screens/subscribetion_view/all_subscribtions.dart';
import 'package:body_coach/services/auth.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
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
    if (_userProfile.isAdmin)
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
              new Container(
                width: 190.0,
                height: 190.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 4,
                  ),
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new AssetImage('assets/trainer/bg3.jpg'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: new Text("RS Doe", textScaleFactor: 1.5),
              )
            ],
          ),
          Divider(),
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => ProfileScreen(
                      uid: profile.uId,
                    ))),
            title: Text(
              'My Profile',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => AllSubscriptions()));
            },
            title: Text(
              'My Subscriptions',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          Divider(),
          !_showAdmin
              ? Text('')
              : ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => SubscribersScreen()));
                  },
                  title: Text(
                    'All Subscribers',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
          !_showAdmin ? Text('') : Divider(),
          ListTile(
            onTap: () async {
              await Auth().logOut();
            },
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.black87,
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
                      color: Colors.black87,
                    ),
                  ),
                ),
          !_showAdmin ? Text('') : Divider(),
          SizedBox(
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
