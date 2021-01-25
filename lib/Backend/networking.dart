import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

const String ERR_CONN = "ERR";
const String CONN = "CONN";

class NetworkHelper{

  /// my openweathermap API key and the API urls
  String apiKey = '';//YOUR API KEY
  String forecastByCoords = 'https://api.openweathermap.org/data/2.5/forecast';
  String currentWeather = 'https://api.openweathermap.org/data/2.5/weather';
  var dataForecast, dataCurrent;

  /// check net connectivity
  Future<bool> checkInternet() async {
    /// check internet connection
    try {
      var result = await InternetAddress.lookup('google.com');
    } on SocketException catch (e) {
      return false;
    }
    return true;
  }



  /// these two methods can also be combined into one
  /// but lets complete the app first
  /// then we'll do this refactoring
  Future<void> getLocationData(double lat, double lon) async {
    http.Response responseForecast, responseCurrent;

    try {
    /// getting current weather
      responseCurrent = await http.get(currentWeather + '?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    /// getting forecast
      responseForecast = await http.get(forecastByCoords + '?lat=$lat&lon=$lon&appid=$apiKey&units=metric');

      if(responseForecast.statusCode == 200 && responseCurrent.statusCode == 200) {
        dataForecast = jsonDecode(responseForecast.body);
        dataCurrent = jsonDecode(responseCurrent.body);
      }
    } catch (e) {
    }

    return CONN;
  }
  Future<void> getCityData(String cityName) async {
    http.Response responseForecast, responseCurrent;
    try {
      /// getting current weather
      responseCurrent = await http.get(currentWeather + '?q=$cityName&appid=$apiKey&units=metric');
      /// getting forecast
      responseForecast = await http.get(forecastByCoords + '?q=$cityName&appid=$apiKey&units=metric');

      if(responseForecast.statusCode == 200 && responseCurrent.statusCode == 200) {
        dataForecast = jsonDecode(responseForecast.body);
        dataCurrent = jsonDecode(responseCurrent.body);
      }
    } catch (e) {
    }
    return;
  }
}
