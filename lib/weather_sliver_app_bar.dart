import 'package:flutter/material.dart';

class WeatherAppbar extends StatelessWidget {
  const WeatherAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const String headerImage = 'https://good-nature-blog-uploads.s3.amazonaws.com/uploads/2022/06/IMG_1057sm-fin-CROP_Web.jpg';
    return SliverAppBar(
      pinned: true,
      stretch: true,
      onStretchTrigger: () async {
        print('Load new data!');
        // await Server.requestNewData();
      },
      backgroundColor: Colors.teal[800],
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
          StretchMode.blurBackground,
        ],

        title: const Text('Dank weather app'),

        background: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: <Color>[Colors.teal[800]!, Colors.transparent],
            ),
          ),
          child: Image.network(
            headerImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}