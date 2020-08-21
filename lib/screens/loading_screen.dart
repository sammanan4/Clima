import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clima/Backend/Weather.dart';
import 'package:clima/screens/home_screen.dart';
import 'package:clima/constants.dart';

const String ERR_CONN = "ERR";
const String CONN = "CONN";
const String NO_LOC = "NO_LOC";

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String status = "Loading";
  bool loading = true;
  bool exit;

  void getLocation() async {
    WeatherData weatherData = WeatherData();
    String result = await weatherData.getLocationWeather();
    if (result == ERR_CONN) {
      setState(() {
        loading = false;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("No Internet Connection !"),
            contentPadding: EdgeInsets.fromLTRB(13.0, 10.0,13.0,1.0),
            backgroundColor: Colors.white,
            elevation: 5.0,
            contentTextStyle: kAlertContentTextStyle,
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  "Exit",
                  style: kAlertButtonTextStyle,
                ),
              ),
            ],
          );
        },
      );
    } else if (result == NO_LOC) {
      setState(() {
        loading = false;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(13.0, 10.0,13.0,1.0),
            content:
                Text("Could not get device location.\nLocation set to default"),
            backgroundColor: Colors.white,
            elevation: 5.0,
            contentTextStyle: kAlertContentTextStyle,
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return HomeScreen(
                          weatherData: weatherData,
                        );
                      }),
                    );
                  },
                  child: Text(
                    "OK",
                    style: kAlertButtonTextStyle,
                  )),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return HomeScreen(
            weatherData: weatherData,
          );
        }),
      );
    }
  }

  @override
  void initState() {
    setState(() {
      exit = false;
    });
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: loading
                  ? Center(
                      child: SpinKitRipple(
                        color: Colors.cyan.shade200,
                        size: 70.0,
                        borderWidth: 10.0,
                      ),
                    )
                  : SizedBox(),
            ),
            Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "Clima",
                    style: kAppTitleTextStyle,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
