import 'package:clima/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CityList extends StatefulWidget {

  /// textFieldController for changing text in field
  /// key to make changes here
  /// changeCityName method to change the actual value of city name
  CityList({@required Key key, @required this.textFieldController, @required this.changeCityName})
      : super(key: key);

  final TextEditingController textFieldController;
  final changeCityName;

  @override
  CityListState createState() => CityListState();
}

class CityListState extends State<CityList> {
  List<String> cityList, cityListTemp;
  String stringCities;
  bool notCalled;
  Color buttonTextColor;


  /// Capitalising text
  String capitalisedText(String item) {
    List<String> words = item.split(" ");
    String result = "";
    words.forEach((w) {
      if (result.isEmpty) {
        if (w.startsWith(RegExp(r"[a-zA-Z]")))
          result = w[0].toUpperCase() + w.substring(1) + " ";
        else{
          result = w + " ";
        }
      } else {
        if (w.startsWith(RegExp(r"[a-zA-Z]")))
          result += w[0].toUpperCase() + w.substring(1) + " ";
        else{
          result += w + " ";
        }
      }
    });
    return result;
  }


  /// create the list of matching city names
  /// from the list of all the city names
  void createTempList(String hint) {
    cityListTemp.clear();
    setState(() {
      cityList.forEach((String item) {
        if (item.toLowerCase().contains(hint)) cityListTemp.add(item);
      });
    });
  }

  /// create a list of the cities
  void createList({String hint = ""}) async {
    if (notCalled) {
      notCalled = false;
      stringCities = await rootBundle.loadString('cities/cityList.txt');
      for (String i in LineSplitter().convert(stringCities)) {
        setState(() {
          if (i.startsWith(hint)) cityList.add(capitalisedText(i));
        });
      }
    } else if(hint.length > 3)
      createTempList(hint);
  }

  @override
  void initState() {
    super.initState();
    cityList = List<String>();
    cityListTemp = List<String>();
    notCalled = true;
    buttonTextColor = Colors.white;
    createList();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.only(left: 10.0, right: 70.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
        ),

        /// scrollable predicted city list
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: cityListTemp.map<Widget>((item) {

            /// using Inkwell to keep button text aligned to left
            return InkWell(
              onTap: () {
                widget.textFieldController.text = item;
                widget.changeCityName(item);
              },
              child: Container(
                height: 40.0,
                child: Text(
                  item,
                  textAlign: TextAlign.left,
                  style: kPredictTextStyle,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
