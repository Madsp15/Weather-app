import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'data_source.dart';
import 'models/time_series.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Weather Chart'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity, // Set the width to fill the available space
            child: FutureBuilder<WeatherChartData>(
              future: context.read<DataSource>().getChartData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final variables = snapshot.data!.daily!;
                return charts.TimeSeriesChart(
                  [
                    for (final variable in variables)
                      charts.Series<TimeSeriesDatum, DateTime>(
                        id: generateName(variable),
                        domainFn: (datum, _) => datum.domain,
                        measureFn: (datum, _) => datum.measure,
                        data: variable.values,
                        colorFn: (_, __) => generateName(variable) == 'Max Temp'
                            ? charts.MaterialPalette.red.shadeDefault
                            : charts.MaterialPalette.blue.shadeDefault,// Customize colors
                ),
                  ],
                  animate: true,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                  behaviors: [
                    charts.SeriesLegend(),
                    charts.ChartTitle('Date',
                        behaviorPosition: charts.BehaviorPosition.bottom),
                    // X-axis label
                    charts.ChartTitle('Temperature °C',
                        behaviorPosition: charts.BehaviorPosition.start),
                    // Y-axis label
                  ],
                  primaryMeasureAxis: charts.NumericAxisSpec(
                      renderSpec:
                          charts.GridlineRendererSpec()), // Show grid lines
                );
              },
            ),
          ),
        ));
  }
}

generateName(TimeSeriesVariable variable) {
    if (variable.name == 'apparent_temperature_max') {
      return 'Max Temp';
    } else if (variable.name == 'apparent_temperature_min') {
      return 'Min Temp';
    } else {
      return '${variable.name} ${variable.unit}';
    }
}
