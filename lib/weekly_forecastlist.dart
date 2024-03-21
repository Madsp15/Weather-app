import 'package:flutter/material.dart';
import 'package:weatherapp/models/models.dart';

import 'main.dart';


class WeeklyForecastList extends StatelessWidget {
  final WeeklyForecastDto weeklyForecast;
  const WeeklyForecastList({super.key, required this.weeklyForecast});

  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();
    final TextTheme textTheme = Theme.of(context).textTheme;
    final daily = weeklyForecast.daily!;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
              final date = DateTime.parse(daily.time![index]);
              final weatherCode = WeatherCode.fromInt(daily.weatherCode![index]);
              final averagetemp = daily.temperature2MMin![index]+daily.temperature2MMax![index]/2;
          return Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 180.0,
                  width: 180.0,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      DecoratedBox(
                        position: DecorationPosition.foreground,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[
                              Colors.grey[800]!,
                              Colors.transparent
                            ],
                          ),
                        ),
                        child: Image.network(

                          weatherCode.weatherImage,
                          scale: 0.1,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Text(
                          weekdayAsString(date),
                          style:
                          textTheme.displaySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10.0),
                        Text(weatherCode.description.toString()),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    '${averagetemp.toStringAsFixed(2)} °C',
                    style: textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          );
        },
        childCount: 7,
      ),
    );
  }
}
String weekdayAsString(DateTime time) {
  return switch (time.weekday) {
    DateTime.monday => 'Mandag',
    DateTime.tuesday => 'Tirsdag',
    DateTime.wednesday => 'Onsdag',
    DateTime.thursday => 'Torsdag',
    DateTime.friday => 'Fredag',
    DateTime.saturday => 'Lørdag',
    DateTime.sunday => 'Søndag',
    _ => ''
  };
}