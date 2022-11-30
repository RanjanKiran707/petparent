part of 'list_loader_bloc.dart';

@immutable
abstract class ListLoaderState {}

class ListLoaderInitial extends ListLoaderState {}

class ListLoaderDone extends ListLoaderState {
  final List list;

  ListLoaderDone(this.list);
}

class ListLoaderError extends ListLoaderState {
  final String error;

  ListLoaderError(this.error);
}
