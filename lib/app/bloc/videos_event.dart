part of 'videos_bloc.dart';

@immutable
abstract class VideosEvent extends Equatable {
  const VideosEvent();

  @override
  List<Object> get props => [];
}

class GetVideos extends VideosEvent {
  @override
  List<Object> get props => [];
}
