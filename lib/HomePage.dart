import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cityController = new TextEditingController();

  String cityName = "london";
  String apiKey = '13cc954ca631900b7b110f728cd82bd0';
  String temperature = "";
  String weather = "";
  String sunrise = "";
  String sunset = "";
  bool isApiCallFinished = false;

  WeatherFactory wf = new WeatherFactory("13cc954ca631900b7b110f728cd82bd0");

  Future getWeather() async {
    try {
      Weather w = await wf.currentWeatherByCityName(cityName);

      setState(() {
        temperature =
            "Temperature : " + w.tempFeelsLike.toString().split(" ")[0] + " °C";
        weather = "Weather : " + w.weatherDescription.toString();
        sunrise = "Sunrise : " +
            w.sunrise.toString().split(" ")[1].substring(0, 5) +
            " am";
        sunset = "Sunset : " +
            w.sunset.toString().split(" ")[1].substring(0, 5) +
            " pm";

        isApiCallFinished = false;
      });
    } catch (e) {
      setState(() {
        isApiCallFinished = false;
        temperature = "Wrong City Name";
        weather = "Wrong City Name";
        sunrise = "Wrong City Name";
        sunset = "Wrong City Name";
      });
    }
  }

  Widget getWidgetAfterAPICall() {
    if (isApiCallFinished) {
      return Padding(
          padding: EdgeInsets.all(50.0),
          child: new CircularProgressIndicator());
    } else
      return SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Text(temperature),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Text(weather),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Text(sunrise),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Text(sunset),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: cityController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelText: 'City',
                  hintText: 'Enter City Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 40.0),
            ),
            RaisedButton(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              textColor: Colors.white,
              color: Colors.orange,
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  cityName = cityController.text.toString();
                  isApiCallFinished = true;
                  this.getWeather();
                });
              },
            ),
            getWidgetAfterAPICall(),
          ],
        ),
      ),
    );
  }
}
