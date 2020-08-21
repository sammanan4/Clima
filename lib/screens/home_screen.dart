import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:clima/constants.dart';
import 'package:clima/Backend/Weather.dart';
import 'package:clima/components/scrollable_forecast.dart';
import 'package:clima/components/tile_list.dart';
import 'package:clima/components/search_drawer.dart';

/// key to identify and call methods of Scrollable Forecast Widget
GlobalKey<ScrollableForecastState> scrollGlobalKey = GlobalKey();

class HomeScreen extends StatefulWidget {
  /// weather Data passed on by the Loading Screen
  HomeScreen({@required this.weatherData});
  final WeatherData weatherData;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// variable declarations for the weather data
  WeatherData weatherData;
  IconData icon;
  String temp,
      windSpeed,
      humid,
      background,
      day,
      time,
      sunrise,
      sunset,
      cityName,
      description;

  /// boolean to specify when to show loading animation
  bool loading;

  void showAbout() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return getAboutDialog(context);
        });
  }

  /// updating the weather using the object passed on by the Loading Screen
  void getLocation() async {
    /// indicating that the new data is being loaded
    /// so start the animation
    setState(() {
      loading = true;
    });

    /// wait for the data from API
    await weatherData.getLocationWeather();

    /// as the data has been acquired from the API
    /// scroll back the weather forecast buttons
    /// and select the first button in the forecast
    setState(() {
      scrollGlobalKey.currentState.resetScrollableData();
    });

    /// update the variables
    updateVariables();
  }

  /// changing state variables
  /// the fromCityName argument indicates that the
  /// scrollable button needs to be rebuilt if weather for
  /// a new city is searched
  /// because the date and time change with cities
  void updateVariables({bool fromCityName = false}) {
    setState(() {
      /// indicate that loading has completed
      loading = false;

      /// set the new values
      weatherData = widget.weatherData;
      temp = weatherData.temp.toStringAsFixed(1) + "\u00B0C";
      windSpeed = weatherData.windSpeed.toString() + " m/s";
      humid = weatherData.humid.toString() + "%";
      cityName = weatherData.cityName;
      description = weatherData.description[0].toUpperCase() +
          weatherData.description.substring(1);
      sunrise = weatherData.sunrise;
      sunset = weatherData.sunset;
      day = weatherData.day;
      time = weatherData.time;
      background = weatherData.background;
      icon = weatherData.icon;

      /// rebuilding the scrollable button list
      if (fromCityName) scrollGlobalKey.currentState.resetScrollableData();
    });
  }

  @override
  void initState() {
    super.initState();

    /// set the variables in the beginning
    updateVariables();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        /// for keyboard to not mess with the layout
        resizeToAvoidBottomPadding: false,

        /// extending the app background to whole screen
        extendBodyBehindAppBar: true,

        /// app bar
        appBar: AppBar(
          /// do not display the leading icon automatically
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black.withOpacity(0.8),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: showAbout,
          ),
          title: Text(
            'Clima Weather',
            style: TextStyle(fontFamily: kFontFamily2),
          ),
          centerTitle: true,

          /// This is like adding a tag line to the app title
          //        bottom: PreferredSize(child: Text("hello"), preferredSize: Size(10.0, 10.0)),
        ),

        /// color that spans over the home screen when drawer is opened
        drawerScrimColor: Colors.black.withOpacity(0.85),

        /// the drawer
        endDrawer: SearchDrawer(
          weatherObject: weatherData,
          updateState: updateVariables,
        ),

        /// Main screen
        body: Container(
          /// decoration to set the background image
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(background), fit: BoxFit.cover),
          ),

          /// set the layout of the screen as scaffold
          child: Scaffold(
            /// appbar stored in constants.dart file
            resizeToAvoidBottomPadding: false,

            /// for the background set by parent to be visible
            backgroundColor: Colors.transparent,

            /// storing contents in a safe area so that content doesn't go out of screen
            body: SafeArea(
              /// minimum padding of the safe area
              minimum: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),

              /// Column Layout for :
              /// temperature card, weather details card, search bar

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  /// space between cards
                  SizedBox(
                    height: 7.0,
                  ),

                  /// sunrise and sunset
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          /// Sunrise
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                WeatherIcons.wi_sunrise,
                                color: Colors.orange,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Sunrise : ",
                                    style: kSunLabelStyle,
                                  ),
                                  Text(
                                    sunrise.toString(),
                                    style: kSunValueStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          /// Sunset
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                WeatherIcons.wi_sunset,
                                color: Colors.deepOrangeAccent,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Sunset : ",
                                    style: kSunLabelStyle,
                                  ),
                                  Text(
                                    sunset.toString(),
                                    style: kSunValueStyle,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// space between cards
                  SizedBox(
                    height: 7.0,
                  ),

                  /// temperature card
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 3,
                    child: Container(
                      /// setting the background weather image
                      decoration: BoxDecoration(
//                        image: DecorationImage(image: AssetImage(background), fit: BoxFit.cover),
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                        color: Colors.black.withOpacity(0.6),
                      ),

                      /// keeping the refresh button inside the card
                      padding:
                          EdgeInsets.only(top: 30.0, left: 20.0, bottom: 24.0),

                      /// the temperature card
                      /// scaffold is required for floating button

                      child: Scaffold(
                        /// keep the weather background
                        backgroundColor: Colors.transparent,

                        /// floating refresh button
                        floatingActionButton: FloatingActionButton(
                          onPressed: getLocation,
                          mini: true,
                          backgroundColor: Colors.black45.withOpacity(0.1),

                          /// is currently refreshing ?
                          child: loading
                              ? SpinKitRing(
                                  color: Colors.white,
                                  size: 20.0,
                                  lineWidth: 3.0,
                                )
                              : Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.endTop,

                        /// temperature, condition, city and time
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TileList(
                                title: Text(
                                  temp,
                                  style: kTempStyle,
                                ),
                                flex: 2,
                              ),
                              TileList(
                                leading: Icon(Icons.location_on),
                                title: Text(
                                  cityName + ", " + day,
                                  style: kCityNameStyle,
                                ),
                              ),
                              TileList(
                                leading: Icon(
                                  icon,
                                  size: 20.0,
                                ),
                                title: Text(
                                  description,
                                  style: kDescriptionStyle,
                                ),
                              ),
                              TileList(
                                leading: Icon(
                                  WeatherIcons.wi_humidity,
                                  size: 20.0,
                                ),
                                title: Row(
                                  children: <Widget>[
                                    Text(
                                      "Humidity : ",
                                      style: kWeatherLabelStyle,
                                    ),
                                    Text(
                                      humid,
                                      style: kWeatherValueStyle,
                                    ),
                                  ],
                                ),
                              ),
                              TileList(
                                leading: Icon(
                                  WeatherIcons.wi_windy,
                                  size: 20.0,
                                ),
                                title: Row(
                                  children: <Widget>[
                                    Text(
                                      "Wind : ",
                                      style: kWeatherLabelStyle,
                                    ),
                                    Text(
                                      windSpeed,
                                      style: kWeatherValueStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// space between cards
                  SizedBox(
                    height: 7.0,
                  ),

                  /// scrollable forecast
                  Flexible(
                    flex: 2,
                    child: ScrollableForecast(
                      /// pass the global key needed call child methods
                      /// from parent
                      ///
                      /// -> passing weatherData class to change values
                      /// in weatherData object.
                      ///
                      /// ->passing the updateVariables method so that
                      /// after changing weatherData, the screen is
                      /// signalled about the change and to update itself
                      ///
                      ///
                      /// pass the scroll controller

                      key: scrollGlobalKey,
                      weatherData: weatherData,
                      updateState: updateVariables,
                    ),
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
