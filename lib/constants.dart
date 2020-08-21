import 'package:flutter/material.dart';

const double toRadians = 3.14 / 180;

const kFontFamily2 = 'trebuc';
const kFontFamily = 'ubuntu';

Widget getAboutDialog(BuildContext context){
  return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(13.0, 10.0, 13.0, 1.0),
      title: Text("About", style: TextStyle(fontFamily: kFontFamily2,),),
      elevation: 10.0,
      content: Container(
        height: 90.0,
        width: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Developer:",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: kFontFamily2, color: Colors.cyan),
            ),
            Text(
              "Sheikh Abdul Manan",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: kFontFamily2,),
            ),
            Text(
              "E-mail:",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: kFontFamily2, color: Colors.cyan),
            ),
            Text(
              "sammanan4@gmail.com",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: kFontFamily2,),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Close",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.cyan,
              fontFamily: kFontFamily2,
            ),
          ),
        ),
      ],
  );
}






TextStyle kTempStyle = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    fontFamily: kFontFamily,
    color: Colors.cyan,
    shadows: <Shadow>[
      Shadow(
        color: Colors.white30,
        offset: Offset.fromDirection(0.0, 3.0),
        blurRadius: 20.0,
      ),
      Shadow(
        color: Colors.white30,
        offset: Offset.fromDirection(90.0 * toRadians, 3.0),
        blurRadius: 20.0,
      ),
    ]);

const kCityNameStyle = TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontFamily: kFontFamily,
  letterSpacing: 1.2,
  fontWeight: FontWeight.w400
);

const kDescriptionStyle = TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.w200,
  fontFamily: kFontFamily,
  letterSpacing: 1.2,
  height: 1.5,
);

const kWeatherLabelStyle = TextStyle(
  color: Colors.cyan,
  fontSize: 14.0,
  fontFamily: kFontFamily,
  fontWeight: FontWeight.w400,
  letterSpacing: 1.2,
  height: 1.5,
);

const kWeatherValueStyle = TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontFamily: kFontFamily,
  fontWeight: FontWeight.w100,
  letterSpacing: 1.0,
  height: 1.5,
);

TextStyle kSunValueStyle = TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontFamily: kFontFamily,
  fontWeight: FontWeight.w100,
);

const kSunLabelStyle = TextStyle(
  color: Colors.cyan,
  fontSize: 14.0,
  fontFamily: kFontFamily,
  fontWeight: FontWeight.w500,
);

const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(8.0),
  hintText: "Search City",
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.elliptical(10.0, 10.0),
    ),
    borderSide: BorderSide.none,
  ),
  filled: true,
  fillColor: Colors.black54,
);

const kTextFieldTextStyle = TextStyle(
  color: Colors.white,
);

const kPredictTextStyle = TextStyle(
  color: Colors.white,
  height: 2.0,
  fontSize: 15.0,
  fontFamily: kFontFamily2,
);

const kAlertButtonTextStyle = TextStyle(
  fontFamily: kFontFamily,
  color: Colors.lightBlue,
  fontSize: 16.0,
);

const kAlertContentTextStyle = TextStyle(
  fontFamily: kFontFamily,
  color: Colors.black,
  fontSize: 16.0,
);

TextStyle kAppTitleTextStyle = TextStyle(
  fontSize: 27.0,
  fontWeight: FontWeight.w900,
  fontFamily: kFontFamily2,
  letterSpacing: 2.3,
  color: Colors.cyan.shade200,
);