import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform_video_player/widgets/android_video_player.dart';

import 'bloc/videos_bloc.dart';

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
    return BlocProvider(
      create: (context) => VideosBloc()..add(GetVideos()),
      child: MaterialApp(
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
      ),
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
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<VideosBloc, VideosState>(
        builder: (context, state) {
          print(state);
          if (state is VideosInitial) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            );
          }
          if (state is VideosLoading) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            );
          }
          if (state is VideosError) {
            return Center(
              child: Text(
                'Failed to load videos.',
                style: theme.textTheme.headline6,
              ),
            );
          }
          if (state is VideosLoaded) {
            var videos = state.videos;
            List<Widget> listItems = [];
            for (int index = 0; index < videos.length; index++) {
              listItems.addAll([
                AndroidVideoPlayer(
                  onNativeWidgetCreated: (controller) {
                    controller.initialize();
                  },
                  key: ValueKey(index),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  child: Text(
                    '${videos[index].title} #$index',
                    style: theme.textTheme.subtitle1,
                  ),
                ),
              ]);
            }
            return ListView(
              children: listItems,
              cacheExtent: 10,
            );
          }
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
            ),
          );
        },
      ),
    );
  }
}
