import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clima/Backend/Weather.dart';
import 'package:clima/Backend/Cities.dart';
import 'package:clima/constants.dart';

GlobalKey<CityListState> cityKey = GlobalKey<CityListState>();

class SearchDrawer extends StatefulWidget {
  final weatherObject, updateState;

  SearchDrawer({@required this.weatherObject, @required this.updateState});

  @override
  _SearchDrawerState createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer> {
  /// for the function getCityWeather to update the weather
  WeatherData weatherData;

  /// the data entered in the text field
  String cityName;

  /// when search button is pressed the animation is to be shown
  bool loading, isButtonDisabled, predictiveText;

  /// the controller used to edit the text field
  /// when a suggestion is selected
  TextEditingController textFieldController;

  @override
  void initState() {
    super.initState();

    /// initialising the local instance of weather data object
    weatherData = widget.weatherObject;

    /// initialisation of the text editing controller
    textFieldController = TextEditingController();

    /// setting the searching animation to false
    setState(() {
      loading = false;
      isButtonDisabled = false;
      cityName = "";
      predictiveText = false;
    });
  }

  /// change the value of the cityName
  void changeCityName(value) {
    setState(() {
      cityName = value;
    });

    /// if length is 3 then start the prediction
    if (value.length > 2) {
      cityKey.currentState.createList(hint: cityName.toLowerCase());
    } else {
      cityKey.currentState.cityListTemp.clear();
    }
  }

  /// when search button is pressed
  Future<void> search() async {
    /// remove focus from text field
    /// to hide the keyboard
    FocusScope.of(context).unfocus();

    /// start the animation by setting
    /// loading variable
    setState(() {
      loading = true;
      isButtonDisabled = true;
    });
    await weatherData.getCityWeather(cityName);

    /// stop animation
    setState(() {
      loading = false;
      isButtonDisabled = false;
    });

    /// update the home screen
    widget.updateState(fromCityName: true);

    /// close the drawer
    Navigator.of(context).pop();

    return;
  }

  @override
  Widget build(BuildContext context) {

    /// add padding for style
    return Padding(
      padding: const EdgeInsets.only(top: 89.0, bottom: 15.0, left: 40.0),

      /// container
      /// sets the color and border radius
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900.withOpacity(0.95),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0)),
        ),

        /// actual widgets
        child: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              /// switch button for predictive text
              ListTile(
                leading: Text("Predictive Text"),
                trailing: Switch(
                  activeColor: Colors.cyan,
                  value: predictiveText,
                  onChanged: (value) {
                    setState(() {
                      predictiveText = value;
                    });
                  },
                ),
              ),

              /// note for performance
              Container(
                padding: EdgeInsets.only(left:13.0, right: 13.0, bottom: 5.0),
                child: Text(
                  "Turning prediction ON might cause performance issues",
                  style: TextStyle(
                    color: Colors.white30,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              /// tile that holds the text field and search button
              ListTile(
                contentPadding: EdgeInsets.all(10.0),

                /// title is the text field
                title: Container(
                  height: 50.0,
                  child: TextField(
                    controller: textFieldController,
                    style: kTextFieldTextStyle,
                    onChanged: changeCityName,

                    /// text field decoration
                    decoration: kTextFieldDecoration,
                  ),
                ),

                /// search button
                trailing: ButtonTheme(
                  minWidth: 10.0,
                  buttonColor: Colors.cyan.shade600,
                  child: RaisedButton(
                    hoverColor: Colors.grey.shade800,
                    disabledColor: Colors.grey.shade800,
                    animationDuration: Duration(seconds: 3),
                    onPressed: cityName.length < 1 || isButtonDisabled? null : search,

                    /// search icon as a child
                    child: Icon(Icons.search),
                  ),
                ),
              ),

              /// if the search button is pressed
              /// and data is still being fetched
              /// then display the animation
              /// otherwise just display a dummy widget
              loading
                  ? SpinKitPulse(
                      color: Colors.white,
                      size: 10.0,
                    )
                  : SizedBox(),

              predictiveText
                  ? CityList(
                      key: cityKey,
                      textFieldController: textFieldController,
                      changeCityName: changeCityName)
                  : Flexible(
                    child: SizedBox(
                height: 290.0,
              ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
