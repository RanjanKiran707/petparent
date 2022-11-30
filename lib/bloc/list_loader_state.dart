part of 'list_loader_bloc.dart';

@immutable
abstract class ListLoaderState extends Equatable {}

class ListLoaderInitial extends ListLoaderState {
  @override
  List<Object?> get props => [];
}

class ListLoaderDone extends ListLoaderState {
  final List list;

  ListLoaderDone(this.list);

  @override
  List<Object?> get props => [list];
}

class ListLoaderError extends ListLoaderState {
  final String error;

  ListLoaderError(this.error);

  @override
  List<Object?> get props => [error];
}
