import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

part 'list_loader_event.dart';
part 'list_loader_state.dart';

class ListLoaderBloc extends Bloc<ListLoaderEvent, ListLoaderState> {
  ListLoaderBloc() : super(ListLoaderInitial()) {
    on<ListLoaderEvent>((event, emit) async {
      if (event is ListLoaderStart) {
        final dio = Dio();

        try {
          final res = await dio.get("http://jsonplaceholder.typicode.com/posts");
          if (res.statusCode != 200) {
            throw Exception(res.statusMessage);
          }
          emit(ListLoaderDone(res.data));
        } catch (e) {
          emit(ListLoaderError(e.toString()));
        }
      }
    });

    add(ListLoaderStart());
  }
}
