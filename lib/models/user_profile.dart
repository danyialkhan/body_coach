import 'package:flutter/foundation.dart';

class UserProfile {
  final String name;
  final String email;
  final String mobileNumber;
  final String imgUrl;
  final String country;
  final String city;
  final String address;
  final DateTime dob;
  final String uId;
  final bool isAdmin;
  final String isoCode;
  final int gender;
  final String therapist;
  final List<dynamic> myStudents;

  UserProfile({
    this.uId,
    this.imgUrl,
    this.name,
    this.city,
    this.mobileNumber,
    this.country,
    this.email,
    this.address,
    this.dob,
    this.isAdmin,
    this.isoCode,
    this.gender,
    this.myStudents,
    this.therapist,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': uId,
      'name': name,
      'email': email,
      'mobile_number': mobileNumber,
      'address': address,
      'country': country,
      'city': city,
      'img': imgUrl,
      'dob': dob,
      'isoCode': isoCode,
      'gender': gender,
      'my-students': myStudents,
      'therapist': therapist,
    };
  }

  UserProfile fromJson(Map<String, dynamic> data) {
    return UserProfile(
      uId: uId,
      address: data['address'],
      city: data['city'],
      country: data['country'],
      dob: data['dob']?.toDate() ?? DateTime.now(),
      email: data['email'],
      imgUrl: data['img'],
      mobileNumber: data['mobile_number'],
      name: data['name'],
      isAdmin: data['isAdmin'],
      isoCode: data['isoCode'],
      gender: data['gender'],
      myStudents: data['my-students'],
      therapist: data['therapist'],
    );
  }

  Map<String, dynamic> toJsonImg() {
    return {
      'img': imgUrl,
    };
  }

}

class DOB with ChangeNotifier {
  String _date;

  String get date {
    return _date;
  }

  void setDate(String date) {
    _date = date;
    notifyListeners();
  }

}
