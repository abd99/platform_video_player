import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform_video_player/app/bloc/videos_bloc.dart';
import 'package:platform_video_player/app/widgets/android_video_player.dart';

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
                  videoURL: videos[index].url,
                  index: index,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  child: Text(
                    '${videos[index].title}',
                    style: theme.textTheme.bodyText1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
