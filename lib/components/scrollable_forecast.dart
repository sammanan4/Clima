import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clima/constants.dart';

class ScrollableForecast extends StatefulWidget {
  /// Get the Key from the parent (through which parent can call
  /// this class's methods
  ///
  /// Get the weather data object which we use when a forecast button is clicked
  ///
  /// Get the update state function from the home screen to indicate the home
  /// screen to update itself with the new date selected

  ScrollableForecast({
    @required Key key,
    @required this.weatherData,
    @required this.updateState,
  }) : super(key: key);
  final weatherData, updateState;

  @override
  ScrollableForecastState createState() => ScrollableForecastState();
}

class ScrollableForecastState extends State<ScrollableForecast> {
  /// Screen controller to link the Scrollable widget to
  /// used when the scrollable forecast buttons need to be scrolled towards the start
  ScrollController scrollDateController, scrollTimeController;

  /// variable which holds the value of current date for which forecast is shown
  /// initial value is 0
  int selectedDate, selectedTime;

  /// weather data local instance
  var weatherData;

  /// list which holds the data that the buttons need to display
  /// the index of button
  /// the date and time it holds
  List dateList, timeList;

  /// when date is changed
  void resetTimeScrollOnly({int index}) {
    setState(() {
      scrollTimeController.animateTo(
        0.0,
        duration: Duration(milliseconds: 1000),
        curve: Curves.decelerate,
      );

      /// set the initial date as current weather
      /// and initialise the button list
      selectedTime = index;

    });
  }

  /// when the home page is refreshed
  /// set every variable to its initial state
  void resetScrollableData({bool fromInitState = false}) {
    setState(() {
      /// if the widget is built for the first time
      if (fromInitState) {
        /// initialise the scroll controller to position 0
        scrollDateController = ScrollController(initialScrollOffset: 0.0);
        scrollTimeController = ScrollController(initialScrollOffset: 0.0);
      }

      /// if this method was called to change the state only
      /// and that the widget was already built
      /// then we just need to scroll back
      else {
        scrollDateController.animateTo(
          0.0,
          duration: Duration(milliseconds: 1000),
          curve: Curves.decelerate,
        );
        scrollTimeController.animateTo(
          0.0,
          duration: Duration(milliseconds: 1000),
          curve: Curves.decelerate,
        );
      }

      /// set the initial date as current weather
      /// and initialise the button list
      selectedDate = 0;
      selectedTime = 0;
      dateList = List();
      timeList = List();

      ///creating local variable to point at weatherData object
      weatherData = widget.weatherData;

      /// the data to display as icon is stored in this list
      List tempList = List<dynamic>();
      List tempTimeList = List<dynamic>();

      /// create the scrollable button list
      for (int i = 0; i < weatherData.count; i++) {
        /// get the time and date and index of the item from weatherData object
        tempList = weatherData.getDateTimeAndIcon(i);

        /// add those dates to the date list which are unique
        /// add list of dates to the time list
        /// each list containing time intervals for a unique day
        if(dateList.length != 0) {
          if(dateList[dateList.length-1][0] != tempList[0]) {
            dateList.add(tempList.sublist(0, 2));
            timeList.add(List.of(tempTimeList));
            tempTimeList.clear();
          }
          tempTimeList.add(tempList.sublist(1));
        }
        else{
          dateList.add(tempList.sublist(0, 2));
          tempTimeList.add(tempList.sublist(1));
        }
      }
      timeList.add(List.of(tempTimeList));
    });
  }

  /// at start ---> set date and time lists
  /// when date button is clicked ---> reset time and home screen
  /// when time button is clicked ---> reset home screen only

  bool findElement(dynamic list){
    bool flag = false;
    list.forEach((element){
      if(element[0] == selectedTime)
        flag = true;
    });
    if(flag) return true;
    return false;
  }


  @override
  void initState() {
    super.initState();

    /// indicate that the widget is getting build for the first time
    resetScrollableData(fromInitState: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[

          /// scrollable time
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollTimeController,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(0.0),

                  /// mapping from the button list
                  /// because the data to be displayed is in the button list
                  children: timeList.firstWhere(findElement).map<Widget>((item) {
                    return RaisedButton(
                      elevation: 0.0,
                      highlightColor: Colors.transparent,
                      color: Colors.transparent,
                      onPressed: () {
                        /// change the current variables
                        weatherData.updateWeather(index: item[0]);

                        /// newly selected date
                        selectedTime = item[0];

                        /// signal the home screen to update itself
                        return widget.updateState();
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /// set the icon and its color
                            /// if not selected then keep it grayish
                            Icon(
                              item[1],
                              size: 20.0,
                              color: selectedTime == item[0]
                                  ? Colors.white
                                  : Colors.white54,
                            ),

                            /// space
                            SizedBox(
                              height: 13.0,
                            ),

                            /// display the time and date
                            Text(
                              item == timeList[0][0] ? "Current" : item[2],
                              style: TextStyle(
                                color: selectedTime == item[0]
                                    ? Colors.white
                                    : Colors.white54,
                                fontFamily: kFontFamily,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ),

          /// space in between
           SizedBox(
            height: 7.0,
          ),

          /// scrollable date
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollDateController,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top:0.0, bottom: 0.0, left: 4.0, right: 4.0),

                  /// mapping from the button list
                  /// because the data to be displayed is in the button list
                  children: dateList.map<Widget>((item) {
                    return RaisedButton(
                      elevation: 0.0,
                      highlightColor: Colors.transparent,
                      color: Colors.transparent,
                      onPressed: () {
                        /// change the current variables
                        weatherData.updateWeather(index: item[1]);

                        /// newly selected date
                        selectedDate = item[1];

                        /// reset the scrollable time
                        resetTimeScrollOnly(index: item[1]);

                        /// signal the home screen to update itself
                        return widget.updateState();
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),

                        /// display the date
                        child: Text(
                          item == dateList[0] ? "Today" : item[0],
                          style: TextStyle(
                            color: selectedDate == item[1] ? Colors.cyan : Colors.white54,
                            fontFamily: kFontFamily,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
