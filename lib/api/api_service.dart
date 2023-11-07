// ignore_for_file: must_be_immutable, avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weatherapi/model/weathermodel.dart';
import 'package:http/http.dart' as http;

class ApiService extends StatefulWidget {
  String location = '';
  var country;
  var state;
  ApiService({
    super.key,
    this.country,
    this.state,
    required this.location,
  });
  @override
  State<ApiService> createState() => _ApiServiceState();
}

class _ApiServiceState extends State<ApiService> {
  @override
  void initState() {
    super.initState();
    getWeatherApi(); // API KEY HERE
  }

  Future<WeatherModel> getWeatherApi() async {
    // String apiKey = '0dc52aa2f93aca02a5f730bd9d2b0712';
    String apiKey = '3f05bf77d0176c8a0d03f6c593006c19';
    String city = widget.location;
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(data);
    } else {
      return WeatherModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text('API Service'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<WeatherModel>(
                future: getWeatherApi(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            'http://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png',
                            fit: BoxFit.cover,
                            height: 200,
                            width: 200,
                          ),
                          Text("Country: ${widget.country}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          Text("Country: ${widget.state}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(
                            'Location: ${data.name}',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Temperature : ${(data.main.temp - 273.15).toStringAsFixed(2)} °C",
                            style: const TextStyle(fontSize: 22),
                          ),
                          Text("Pressure : ${data.main.pressure - 760} hPa",
                              style: const TextStyle(fontSize: 22)),
                          Text(' Humidity: ${data.main.humidity} %',
                              style: const TextStyle(fontSize: 22)),
                          Text(' Description: ${data.weather[0].description}.',
                              style: const TextStyle(fontSize: 22)),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            const Positioned(
                bottom: 0,
                child: Stack(
                  children: [Text('Cpoyright Ⓒ by Nabin Yadav')],
                ))
          ],
        ),
      ),
    );
  }
}
