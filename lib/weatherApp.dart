import "dart:convert";
import "dart:ui";
import 'package:flutter/material.dart';

import "additionalcard.dart";
import "forecastCard.dart";
import 'package:intl/intl.dart';
import "package:http/http.dart" as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {

  late Future<Map<String, dynamic>> weatherData;


  @override
  void initState() {
    super.initState();
    weatherData = getWeatherData();
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    await dotenv.load(fileName: "assets/.env");
    String city = "Tashkent";
    try {
      final res = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/forecast?q=$city,uz&APPID=${dotenv.env["apiWeather"]}"));

      final data = jsonDecode(res.body);

      if (data["cod"] != "200") {
        throw "An unexpected error occured in weather api";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Ob-havo",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => {
                  setState(() {
                    weatherData = getWeatherData();
                  })
                },
              )
            ]),
        body: FutureBuilder(
            future: weatherData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong!"));
              }

              final data = snapshot.data!;
              final currentValue = data["list"][0];

              final currentTempreture =
                  (currentValue["main"]["temp"] - 273.15).toStringAsFixed(2);
              final currentSkyState = currentValue["weather"][0]["main"];
              final currentPressure =
                  currentValue["main"]["pressure"].toString();
              final currentWindSpeed = currentValue["wind"]["speed"].toString();
              final currentHumidity =
                  currentValue["main"]["humidity"].toString();
              List<dynamic> weatherList = data["list"].sublist(1);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // main card
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          //  "${double.parse((currentDagree- 273.15).toStringAsFixed(2))}°",
                                          "$currentTempreture°",
                                          style: const TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Icon(
                                          currentSkyState == "Clouds" ||
                                                  currentSkyState == "Rain"
                                              ? Icons.cloud
                                              : Icons.sunny,
                                          size: 86,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Text(currentSkyState,
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // weather list
                        const Text(
                          "Hourly forecast",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        //  SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(
                        //     children: forecast,
                        //   ),
                        // ),
                        SizedBox(
                          height: 160,
                          
                          child: ListView.builder(
                            
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                                  final time = DateTime.parse(weatherList[index]["dt_txt"]);
                
                            
                                return ForecastCard(
                                    date: DateFormat.Md().format(time).toString(),
                                    time: DateFormat.Hm().format(time).toString(),
                                    icon: weatherList[index]["weather"][0]["main"] ==
                                                "Clouds" ||
                                            weatherList[index]["weather"][0]["main"] ==
                                                "Rain"
                                        ? Icons.cloud
                                        : Icons.sunny,
                                    dagree:
                                        "${(weatherList[index]["main"]["temp"] - 273.15).toStringAsFixed(2)}°");
                              }
                            
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Additional information",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        // extra info
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            AdditionalInfoCard(
                                icon: Icons.opacity,
                                text: "Humidity",
                                data: currentHumidity),
                            AdditionalInfoCard(
                                icon: Icons.air,
                                text: "Wind Speed",
                                data: currentWindSpeed),
                            AdditionalInfoCard(
                                icon: Icons.compress,
                                text: "Pressure",
                                data: currentPressure),
                          ],
                        )
                      ]),
                ),
              );
            }));
  }
}
