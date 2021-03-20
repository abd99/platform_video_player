import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:platform_video_player/app/data/videos_list.dart';
import 'package:platform_video_player/app/models/video.dart';

part 'videos_event.dart';
part 'videos_state.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  VideosBloc() : super(VideosInitial());

  List<Video> items = [];
  @override
  Stream<VideosState> mapEventToState(
    VideosEvent event,
  ) async* {
    final currentState = state;
    if (event is GetVideos) {
      try {
        if (currentState is VideosInitial) yield VideosLoading();
        await Future.delayed(Duration(seconds: 2), () {
          items.addAll(videosList);
        });
        yield VideosLoaded(
          videos: items,
        );
      } catch (e) {
        debugPrint('VideoPlayerFailure: ${e.toString()}');
        yield VideosError(e.toString());
      }
    }
  }
}
