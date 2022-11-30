import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:petparent/data/repository/global_repository.dart';

part 'list_loader_event.dart';
part 'list_loader_state.dart';

class ListLoaderBloc extends Bloc<ListLoaderEvent, ListLoaderState> {
  final IRepository gRepository;
  ListLoaderBloc(this.gRepository) : super(ListLoaderInitial()) {
    on<ListLoaderEvent>((event, emit) async {
      if (event is ListLoaderStart) {
        try {
          final data = await gRepository.getList();
          emit(ListLoaderDone(data));
        } catch (e) {
          emit(ListLoaderError(e.toString()));
        }
      }
    });

    add(ListLoaderStart());
  }
}
