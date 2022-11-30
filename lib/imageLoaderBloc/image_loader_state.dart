part of 'image_loader_bloc.dart';

@immutable
abstract class ImageLoaderState {}

class ImageLoaderInitial extends ImageLoaderState {}

class ImageLoaderLoaded extends ImageLoaderState {
  final Uint8List ans;

  ImageLoaderLoaded(this.ans);
}

class ImageLoaderError extends ImageLoaderState {
  final String exception;

  ImageLoaderError(this.exception);
}

class ImageLoaderSaved extends ImageLoaderState {}
