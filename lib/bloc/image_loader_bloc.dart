import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petparent/data/repository/global_repository.dart';

part 'image_loader_event.dart';
part 'image_loader_state.dart';

class ImageLoaderBloc extends Bloc<ImageLoaderEvent, ImageLoaderState> {
  late Uint8List image;

  final IRepository gRepository;
  ImageLoaderBloc(this.gRepository) : super(ImageLoaderInitial()) {
    on<ImageLoaderEvent>((event, emit) async {
      if (event is ImageStart) {
        if (state is! ImageLoaderInitial) {
          emit(ImageLoaderInitial());
        }
        try {
          image = await gRepository.getImage();
          emit(ImageLoaderLoaded(image));
        } catch (e) {
          emit(ImageLoaderError(e.toString()));
        }
      } else if (event is ImageSave) {
        await Hive.box("image").clear();
        await Hive.box("image").add(image);
        emit(ImageLoaderSaved());
      }
    });
  }
}
