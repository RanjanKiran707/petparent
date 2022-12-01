part of 'image_loader_bloc.dart';

@immutable
abstract class MediaState extends Equatable {}

class MediaLoading extends MediaState {
  @override
  List<Object?> get props => [];
}

class MediaImageLoaded extends MediaState {
  final Uint8List ans;

  MediaImageLoaded(this.ans);

  @override
  List<Object?> get props => [ans];
}

class MediaVideoLoaded extends MediaState {
  final VideoPlayerController videoPlayerController;

  MediaVideoLoaded(this.videoPlayerController);

  @override
  List<Object?> get props => [];
}

class MediaError extends MediaState {
  final String exception;

  MediaError(this.exception);

  @override
  List<Object?> get props => [exception];
}
