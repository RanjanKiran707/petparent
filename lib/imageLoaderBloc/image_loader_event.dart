part of 'image_loader_bloc.dart';

@immutable
abstract class ImageLoaderEvent {}

class ImageStart extends ImageLoaderEvent {}

class ImageSave extends ImageLoaderEvent {}
