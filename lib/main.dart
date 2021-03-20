import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_video_player/widgets/android_video_player.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(PlatformVideoPlayerApp());
}

class PlatformVideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Video Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
            color: Colors.white,
            brightness: Brightness.light,
            textTheme: TextTheme(
              headline6: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black,
                  ),
            ),
            elevation: 0.0),
      ),
      home: HomePage(title: 'Platform Video Player'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: List.generate(
          1,
          (index) => AndroidVideoPlayer(
            onNativeWidgetCreated: (controller) {},
            key: ValueKey(index),
          ),
        ),
      ),
    );
  }
}
