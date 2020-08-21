import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:clima/Backend/Location.dart';
import 'networking.dart';

const String ERR_CONN = "ERR";
const String CONN = "CONN";
const String NO_LOC = "NO_LOC";


class WeatherData {

  /// http helper
  NetworkHelper networkHelper;

  /// data variable holds the json decoded data
  var dataForecast, dataCurrent;

  /// holds the number of forecast conditions retrieved (40 for free API)
  int count;

  /// variables that are displayed
  /// these variables take the values from the list of forecast data
  var temp,
      windSpeed,
      humid,
      weatherID,
      cityName,
      description,
      sunrise,
      sunset,
      day,
      time,
      background,
      icon;

  /// list of forecast data that is stored
  var tempList,
      windSpeedList,
      humidList,
      weatherIDList,
      descriptionList,
      dayList,
      timeList,
      backgroundList,
      iconList;

  /// these variables are used temporarily
  var dummyVar;
  var sunriseUtc, sunsetUtc, watchUtc;
  bool night;

  WeatherData() {
    networkHelper = NetworkHelper();
    tempList = List<dynamic>();
    windSpeedList = List<dynamic>();
    humidList = List<dynamic>();
    weatherIDList = List<dynamic>();
    descriptionList = List<dynamic>();
    dayList = List<dynamic>();
    timeList = List<dynamic>();
    backgroundList = List<dynamic>();
    iconList = List<dynamic>();
    dummyVar = List<dynamic>();
  }

  /// getting the coordinates of the user
  Future<String> getLocationWeather() async {

    String returnValue = CONN;

    /// check if internet is connected
    /// return error status
    bool conn = await networkHelper.checkInternet();
    if(!conn)
      return ERR_CONN;


    /// get location
    /// if no location access set default city
    Location location = Location();
    bool loc = await location.getCurrentLocation();
    if (!loc){
      returnValue = NO_LOC;
      await networkHelper.getLocationData(24.468611, 39.61417);
    }
    else{
      await networkHelper.getLocationData(location.lat, location.lon);
    }

    /// get the data
    dataCurrent = networkHelper.dataCurrent;
    dataForecast = networkHelper.dataForecast;

    /// set the variables
    _createDataList(dataCurrent, dataForecast);
    updateWeather();

    /// return the status
    return returnValue;
  }

  /// getting the weather based on city name
  /// its essentially same as above
  /// these two methods can be refactored into one
  /// no time for that for now
  Future<void> getCityWeather(String cityName) async {
    await networkHelper.getCityData(cityName);
    dataCurrent = networkHelper.dataCurrent;
    dataForecast = networkHelper.dataForecast;
    _createDataList(dataCurrent, dataForecast);
    updateWeather();
    return;
  }

  void _clearLists() {
    weatherIDList.clear();
    descriptionList.clear();
    tempList.clear();
    humidList.clear();
    windSpeedList.clear();
    timeList.clear();
    dayList.clear();
    backgroundList.clear();
    iconList.clear();
  }

  /// Longest Function uuuuhhhhhh !!!!!
  /// create the list of weather forecast
  void _createDataList(dynamic dataCurrent, dynamic dataForecast) {
    cityName = dataCurrent['name'];

    /// getting the time
    /// and shifting it according to the timezone
    /// the time is provided in UTC
    sunriseUtc = DateTime.fromMillisecondsSinceEpoch(
            dataCurrent['sys']['sunrise'] * 1000)
        .toUtc()
        .add(Duration(seconds: dataCurrent['timezone']));
    sunsetUtc =
        DateTime.fromMillisecondsSinceEpoch(dataCurrent['sys']['sunset'] * 1000)
            .toUtc()
            .add(Duration(seconds: dataCurrent['timezone']));

    /// convert the datetime objects into strings of desired style
    sunrise = DateFormat('jm').format(sunriseUtc).toLowerCase();
    sunset = DateFormat('jm').format(sunsetUtc).toLowerCase();

    /// get the count fo the number of forecast items
    count = dataForecast['cnt'];

    /// clear the lists if already set before
    /// ( this condition arises when weather is already displayed
    ///   and the user searches for the weather of a city)
    /// ( then the lists need be rebuilt, so previous lists need to be
    ///   deleted)
    _clearLists();

    /// place current data in the list
    weatherIDList.add(dataCurrent['weather'][0]['id']);
    descriptionList.add(dataCurrent['weather'][0]['description']);
    tempList.add(dataCurrent['main']['temp']);
    humidList.add(dataCurrent['main']['humidity']);
    windSpeedList.add(dataCurrent['wind']['speed']);

    /// datetime object and adjust for shift from utc
    watchUtc = DateTime.fromMillisecondsSinceEpoch(dataCurrent['dt'] * 1000)
        .toUtc()
        .add(Duration(seconds: dataCurrent['timezone']));

    /// same procedure as done for sunrise and sunset
    timeList.add(DateFormat('jm').format(watchUtc).toLowerCase());
    dayList.add(DateFormat('d MMM').format(watchUtc));

    String tempStr = DateFormat('jm').format(watchUtc).toLowerCase();
    if((tempStr.endsWith("pm") && tempStr.startsWith(new RegExp(r"(6|7|8|9|10|11)")))||(tempStr.endsWith('am')&&tempStr.startsWith(new RegExp(r"(12|1|2|3|4|5|6)"))))
      night = true;
    else
      night = false;

    /// gets the icon and image that need to be displayed
    /// icon is of type IconData
    /// for image data a path to the asset is provided
    /// which is then converted to image in the home page
    dummyVar = getBackgroundAndIcon(dataCurrent['weather'][0]['id'], night);
    backgroundList.add(dummyVar[0]);
    iconList.add(dummyVar[1]);
    dummyVar.clear();

    /// place forecast data in the list
    /// same procedure as above but for the forecast data
    ///
    for (int index = 0; index < count; index++) {

      weatherIDList.add(dataForecast['list'][index]['weather'][0]['id']);
      descriptionList
          .add(dataForecast['list'][index]['weather'][0]['description']);
      tempList.add(dataForecast['list'][index]['main']['temp']);
      humidList.add(dataForecast['list'][index]['main']['humidity']);
      windSpeedList.add(dataForecast['list'][index]['wind']['speed']);

      watchUtc = DateTime.fromMillisecondsSinceEpoch(
              dataForecast['list'][index]['dt'] * 1000)
          .toUtc()
          .add(Duration(seconds: dataForecast['city']['timezone']));

      timeList.add(DateFormat('jm').format(watchUtc).toLowerCase());
      dayList.add(DateFormat('d MMM').format(watchUtc));

      /// day night logic
      tempStr = DateFormat('jm').format(watchUtc).toLowerCase();
      if((tempStr.endsWith("pm") && tempStr.startsWith(new RegExp(r"(6|7|8|9|10|11)")))||(tempStr.endsWith('am')&&tempStr.startsWith(new RegExp(r"(12|1|2|3|4|5|6)"))))
        night = true;
      else
        night = false;

      dummyVar =
          getBackgroundAndIcon(dataForecast['list'][index]['weather'][0]['id'], night);
      backgroundList.add(dummyVar[0]);
      iconList.add(dummyVar[1]);
      dummyVar.clear();
    }
  }

  /// update the data to display
  ///
  /// the index is required because if the scrollable time button
  /// is pressed then the display data needs to be updated
  /// and the data resides in the forecast list
  /// the scrollable button sends the index of the item in the list
  /// to be displayed
  void updateWeather({int index = 0}) {
    weatherID = weatherIDList[index];
    description = descriptionList[index];
    temp = tempList[index];
    humid = humidList[index];
    windSpeed = windSpeedList[index];
    time = timeList[index];
    day = dayList[index];
    background = backgroundList[index];
    icon = iconList[index];
  }

  /// specific function to return the date and time for scrollable buttons
  List<dynamic> getDateTimeAndIcon(int index) {
    var list = List<dynamic>();
    list.add(dayList[index]);
    list.add(index);
    list.add(iconList[index]);
    list.add(timeList[index]);
    return list;
  }

  /// getting the background according to the weather
  List<dynamic> getBackgroundAndIcon(int id, bool night) {
    String condition = "Day";
    if(night)
      condition = "Night";
    switch (id ~/ 100) {
      case 2:
        return ["assets/thunderstorm.jpg", WeatherIcons.wi_thunderstorm];
        break;
      case 3:
        return ["assets/rainLight.jpg", WeatherIcons.wi_rain];
        break;
      case 5:
        if (id <= 501)
          return ["assets/rainLight.jpg", WeatherIcons.wi_rain];
        else
          return ["assets/rainHeavy.jpg", WeatherIcons.wi_rain];
        break;
      case 6:
        return ["assets/snow$condition.png", WeatherIcons.wi_snow];
        break;
      case 7:
        switch ((id ~/ 10) % 10) {
          case 0:
          case 1:
          case 2:
          case 3:
          case 4:
            return ["assets/fog$condition.jpg", WeatherIcons.wi_fog];
          case 5:
            return ["assets/sand.jpg", WeatherIcons.wi_sandstorm];
          case 6:
          case 7:
          case 8:
            return ["assets/tornado.jpg", WeatherIcons.wi_tornado];
        }
        break;
      case 8:
        if (id >= 801 && id <= 803)
          return ["assets/fewClouds$condition.jpg", WeatherIcons.wi_wu_partlycloudy];
        else if (id == 804)
          return ["assets/overcast.png", WeatherIcons.wi_cloudy];
        break;
    }
    return ["assets/clear$condition.jpg", WeatherIcons.wi_wu_sunny];
  }
}
