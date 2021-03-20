import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:platform_video_player/models/video.dart';

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
          for (var i = 0; i < 20; i++) {
            items.add(Video("title", "url"));
          }
        });
        yield VideosLoaded(
          videos: items,
        );
      } catch (e) {
        print('VideoPlayerFailure: ${e.toString()}');
        yield VideosError(e.toString());
      }
    }
  }
}
