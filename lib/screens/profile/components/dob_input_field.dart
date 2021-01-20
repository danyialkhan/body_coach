import 'package:body_coach/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

class DOBInputField extends StatelessWidget {

  final Function onConfirm;

  DOBInputField({this.onConfirm});

  String _dob;
  @override
  Widget build(BuildContext context) {
    return Row(
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
              color: Colors.black,
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
                  onConfirm: onConfirm,
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
                            : Colors.black,
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
    );
  }
}
