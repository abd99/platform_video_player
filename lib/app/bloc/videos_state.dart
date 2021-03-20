part of 'videos_bloc.dart';

@immutable
abstract class VideosState extends Equatable {
  const VideosState();

  @override
  List<Object> get props => [];
}

class VideosInitial extends VideosState {
  const VideosInitial();
  @override
  List<Object> get props => [];
}

class VideosLoading extends VideosState {
  const VideosLoading();
  @override
  List<Object> get props => [];
}

class VideosLoaded extends VideosState {
  final List<Video> videos;
  const VideosLoaded({
    this.videos,
  });

  @override
  List<Object> get props => [videos];

  @override
  String toString() => 'Videos Data loaded { videos: ${videos.length} }';
}

class VideosError extends VideosState {
  final String message;
  const VideosError(this.message);
  @override
  List<Object> get props => [message];
}
