import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:weather/widgets/Weather.dart';
import 'package:weather/widgets/WeatherItem.dart';
import 'package:weather/models/WeatherData.dart';
import 'package:weather/models/ForecastData.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool isLoading = false;
  WeatherData weatherData;
  ForecastData forecastData;

  @override
  void initState() {
    super.initState();

    loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text('Flutter Weather App'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: weatherData != null ? Weather(weather: weatherData) : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isLoading ? CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: new AlwaysStoppedAnimation(Colors.white),
                      ) : IconButton(
                        icon: new Icon(Icons.refresh),
                        tooltip: 'Refresh',
                        onPressed: loadWeather,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200.0,
                    child: forecastData != null ? ListView.builder(
                        itemCount: forecastData.list.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => WeatherItem(weather: forecastData.list.elementAt(index))
                    ) : Container(),
                  ),
                ),
              )
            ]
          )
        )
      ),
    );
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

    final lat = 40.730610;
    final lon = -73.935242;
    final weatherResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?APPID=21894456df795e3f52963983c3e98f01&lat=${lat
            .toString()}&lon=${lon.toString()}');
    final forecastResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?APPID=21894456df795e3f52963983c3e98f01&lat=${lat
            .toString()}&lon=${lon.toString()}');

    if (weatherResponse.statusCode == 200 &&
        forecastResponse.statusCode == 200) {
      return setState(() {
        weatherData = new WeatherData.fromJson(jsonDecode(weatherResponse.body));
        forecastData = new ForecastData.fromJson(jsonDecode(forecastResponse.body));
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }
}