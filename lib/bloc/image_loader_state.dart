part of 'image_loader_bloc.dart';

@immutable
abstract class ImageLoaderState extends Equatable {}

class ImageLoaderInitial extends ImageLoaderState {
  @override
  List<Object?> get props => [];
}

class ImageLoaderLoaded extends ImageLoaderState {
  final Uint8List ans;

  ImageLoaderLoaded(this.ans);

  @override
  List<Object?> get props => [ans];
}

class ImageLoaderError extends ImageLoaderState {
  final String exception;

  ImageLoaderError(this.exception);

  @override
  List<Object?> get props => [exception];
}

class ImageLoaderSaved extends ImageLoaderState {
  @override
  List<Object?> get props => [];
}
