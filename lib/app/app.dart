import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform_video_player/app/bloc/videos_bloc.dart';
import 'package:platform_video_player/app/screens/home_page.dart';

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
