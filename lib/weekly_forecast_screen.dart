import 'package:flutter/material.dart';
import 'package:weatherapp/data_source.dart';

import 'package:weatherapp/models/models.dart';
import 'chart_screen.dart';
import 'weather_sliver_app_bar.dart';
import 'weekly_forecastlist.dart';
import 'dart:async';
//ChartScreen()
class WeeklyForecastScreen extends StatelessWidget {
  const WeeklyForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Forecast'),
        actions: [
          IconButton(
            icon: Icon(Icons.show_chart), // You can choose any icon you like
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChartScreen()), // Replace with your ChartScreen widget
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: RealDataSource().getWeeklyForecast(),
        builder: (context, snapshot) => RefreshIndicator(
          onRefresh: () {
            return RealDataSource().getWeeklyForecast();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              const WeatherAppbar(),
              if (snapshot.hasData)
                WeeklyForecastList(weeklyForecast: snapshot.data!),
              if (snapshot.hasError)
                buildError(snapshot)
              else
                buildSpinner(),
            ],
          ),
        ),
      ),
    );
  }
  SliverToBoxAdapter buildError(AsyncSnapshot<WeeklyForecastDto> snapshot) {
    return SliverToBoxAdapter(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(snapshot.error.toString())));
  }

  Widget buildSpinner() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Future<void> loadForecast() async {
    await RealDataSource().getWeeklyForecast();
  }
}
