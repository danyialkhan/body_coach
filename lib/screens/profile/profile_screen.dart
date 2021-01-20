import 'package:body_coach/models/user_profile.dart';
import 'package:body_coach/screens/profile/components/email_input_field.dart';
import 'package:body_coach/screens/profile/components/text_input_field.dart';
import 'package:body_coach/services/user_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:body_coach/shared/image.dart';
import 'package:body_coach/shared/image_functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  ProfileScreen({this.uid});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _isLoading = false;
  final TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  String _dob;
  String _therapist;
  List<String> genderList = ['Gender', 'Male', 'Female'];
  int _currentGender;
  bool checkNewsletter = false;

  // form values
  String _currentName;
  String _currentEmail;
  DateTime _currentDate;
  String _phoneNumber;

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred!'),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: StreamBuilder<UserProfile>(
        stream: UserService(uId: widget.uid).getUserStream(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            UserProfile userProfile = snapshot.data;
            _dob = userProfile?.dob == null
                ? "DD-MM-YYYY"
                : '${userProfile.dob.day.toString().padLeft(2, '0')}-${userProfile.dob.month.toString().padLeft(2, '0')}-${userProfile.dob.year}';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        backgroundColor: purpleShad,
                      ))
                    : Expanded(
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // empty space
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),

                                //space to upload profile pic
                                Consumer<ImagePath>(
                                  builder: (_, path, __) {
                                    return GestureDetector(
                                      onTap: () async {
                                        await getImage(context);
                                        try {
                                          if (path.path != null) {
                                            _toggleLoading();
                                            String url = await ImageFunctions
                                                .uploadSentImage(path.path,
                                                    'UserProfile/${widget.uid}');
                                            await UserService(uId: widget.uid)
                                                .updateUserProfileImageLink(
                                                    imgUrl: url);
                                            path.clear();
                                            _toggleLoading();
                                          }
                                        } catch (e) {
                                          _toggleLoading();
                                          _showErrorDialog(
                                              "Cannot upload Image!");
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[400],
                                          ),
                                          child: userProfile?.imgUrl == null
                                              ? Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.08,
                                                )
                                              : Image.network(
                                                  userProfile.imgUrl),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // a line...
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                  ),
                                ),

                                // Name field
                                TextInputField(
                                  label: 'Name',
                                  name: userProfile?.name,
                                  hintText: 'Name',
                                  validator: (val) => val.isEmpty
                                      ? 'Please enter a name'
                                      : null,
                                  onChanged: (val) => _currentName = val,
                                ),

                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[300]),
                                    ),
                                  ),
                                ),

                                TextInputField(
                                  label: 'Coach',
                                  name: userProfile?.therapist,
                                  hintText: 'Coach or therapist name',
                                  validator: (val) => val.isEmpty
                                      ? 'Please enter a name'
                                      : null,
                                  onChanged: (val) => _therapist = val,
                                ),

                                // a line...
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                  ),
                                ),

                                // Email field
                                EmailInputField(
                                  title: 'Email',
                                  email: userProfile?.email,
                                  hint: 'Email',
                                  validator: (val) {
                                    RegExp reg = RegExp(
                                        r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$");
                                    if (val.isEmpty) {
                                      return "Please enter email";
                                    }
                                    if (!reg.hasMatch(val)) {
                                      return "Enter valid email";
                                    }
                                    return null;
                                  },
                                  onChanged: (val) => _currentEmail = val,
                                ),

                                // a line...
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                  ),
                                ),

                                //Birthday field
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      child: Text(
                                        'Birthday',
                                        style: TextStyle(
                                          color: whiteShad,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                      ),
                                    ),
                                    Consumer<DOB>(
                                      builder: (_, data, __) {
                                        _dob = data.date == null
                                            ? _dob
                                            : data.date;
                                        return GestureDetector(
                                          onTap: () {
                                            DatePicker.showDatePicker(
                                              context,
                                              // theme: DatePickerTheme(
                                              //   containerHeight: 210.0,
                                              // ),
                                              showTitleActions: true,
                                              minTime: DateTime(1900, 1, 1),
                                              maxTime: DateTime.now(),
                                              onConfirm: (date) {
                                                print('confirm $date');
                                                _dob =
                                                    '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
                                                var dob = Provider.of<DOB>(
                                                    context,
                                                    listen: false);
                                                dob.setDate(_dob);
                                                _currentDate = date;
                                              },
                                              currentTime: DateTime.now(),
                                              // locale: LocaleType.en,
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  _dob,
                                                  style: TextStyle(
                                                    color: _dob == 'DD-MM-YYYY'
                                                        ? Colors.grey
                                                        : whiteShad,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.date_range,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                // a line...
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                  ),
                                ),

                                // phone field
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      child: Text(
                                        'Phone Number',
                                        style: TextStyle(
                                          color: whiteShad,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      child: TextFormField(
                                        initialValue: userProfile?.mobileNumber,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return "Please enter phone number";
                                          }
                                          return null;
                                        },
                                        onChanged: (val) => _phoneNumber = val,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: '000-000-000',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          color: whiteShad,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                  ),
                                ),

                                // Gender field
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      child: Text(
                                        'Gender',
                                        style: TextStyle(
                                          color: whiteShad,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      child: DropdownButtonFormField(
                                        validator: (val) {
                                          if (val == 'Gender') {
                                            return 'Please Select a gender';
                                          }
                                          return null;
                                        },
                                        value: genderList[
                                            (userProfile?.gender ?? 0) + 1],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          color: genderList[
                                                      (userProfile?.gender ??
                                                              0) +
                                                          1] ==
                                                  'Gender'
                                              ? Colors.grey
                                              : whiteShad,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        items: genderList.map((gender) {
                                          return DropdownMenuItem(
                                            value: gender,
                                            child: Text('$gender'),
                                          );
                                        }).toList(),
                                        onChanged: (val) => setState(() {
                                          _currentGender =
                                              genderList.indexWhere(
                                                  (item) => item == val);
                                          print(_currentGender);
                                          _currentGender -= 1;
                                        }),
                                      ),
                                    ),
                                  ],
                                ),

                                // a line...
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                  ),
                                ),

                                // empty space
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),

                                // empty space
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),

                                // button to update profile
                                GestureDetector(
                                  onTap: () async {
                                    if (_formKey.currentState.validate()) {
                                      _toggleLoading();
                                      await UserService(uId: widget.uid)
                                          .updateUser(
                                        mobileNumber: _phoneNumber ?? userProfile.mobileNumber,
                                        email: _currentEmail ??
                                            userProfile.email,
                                        gender: _currentGender ??
                                            (userProfile?.gender ?? 0),
                                        name: _currentName ?? userProfile.name,
                                        dob: _currentDate ?? userProfile.dob,
                                        imgUrl: userProfile.imgUrl,
                                        therapist: _therapist ?? userProfile.therapist,
                                      );
                                      _toggleLoading();
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width *
                                        0.76,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    margin: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.015,
                                    ),
                                    decoration: BoxDecoration(
                                      color: lightBlue,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                      ),
                                    ),
                                    child: Text(
                                      'Update',
                                      style: TextStyle(
                                        color: whiteShad,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.025,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                // empty space
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          }
        },
      ),
    );
  }
}
