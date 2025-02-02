// ignore: file_names

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secret.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Varanasi';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,&APPID=$openWeatherAPIKey'),
      );
      // print(temp);
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured ';
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
        title:
            Text('Weather App', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                
              });
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          //setting data for application
          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];

          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main Card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Text(
                                    '$currentTemp°K',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Icon(
                                    currentSky == 'Cloud' ||
                                            currentSky == 'Rain'
                                        ? Icons.cloud
                                        : Icons.sunny,
                                    size: 72,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    currentSky,
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Weather Forecast Cards

                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (int i= 1; i <= 5;++i)
                  //         HorlyForecast(
                  //           time: data['list'][i]['dt'].toString(),
                  //           icon: data['list'][i]['weather'][0]['main']=='Cloud'||data['list'][i]['weather'][0]['main']=='Rain'?Icons.cloud:Icons.sunny,
                  //           temprature: '${data['list'][i]['main']['temp']}°K',
                  //         ),

                  //     ],
                  //   ),
                  // ),

                  SizedBox(
                    height: 125,
                    child: ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final hourlyForecast = data['list'][index + 1];
                          final hourlySky =
                              data['list'][index + 1]['weather'][0]['main'];
                          final hourlytemp = hourlyForecast['main']['temp'].toString();
                          final time= DateTime.parse(hourlyForecast['dt_txt']);
                          return HorlyForecast(
                            time: DateFormat.Hm().format(time),
                            temprature: '$hourlytemp°K',
                            icon: hourlySky=='Clouds'||hourlySky=='Rain'
                            ?Icons.cloud:
                            Icons.sunny,
                    
                          );
                        }),
                  ),
                  //Additional
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditonalInfo(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditonalInfo(
                        icon: Icons.air,
                        label: 'Wind Speed ',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditonalInfo(
                          icon: Icons.wind_power,
                          label: 'Pressure',
                          value: currentPressure.toString()
                          ),
                    ],
                  ),
                ],
              ),
            ),
            
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(16, 255, 255, 255),
        child:SizedBox(
          height: 50,
          child: Center(
           child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 5,),
              Text('VARANASI',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
           ),
          ),
        )
      ),
    );
  }
}
