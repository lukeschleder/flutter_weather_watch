import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_weather_watch/models/weather.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late Future<Weather> _futureWeather;

  @override
  void initState() {
    super.initState();
    _futureWeather =
        Weather.fetch(dotenv.env['open_weather_api'] ?? '', 44.9778, -93.2650);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather Watch'),
        ),
        body: Center(
          child: FutureBuilder<Weather>(
            future: _futureWeather,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final weather = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${weather.temperature}°C',
                      style: const TextStyle(fontSize: 48),
                    ),
                    Image.network(weather.iconUrl),
                    Text(
                      weather.description,
                      style: const TextStyle(fontSize: 24),
                    ),
                    Text(
                      weather.locationName,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
