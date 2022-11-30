import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'image_loader_event.dart';
part 'image_loader_state.dart';

class ImageLoaderBloc extends Bloc<ImageLoaderEvent, ImageLoaderState> {
  late Uint8List image;
  ImageLoaderBloc() : super(ImageLoaderInitial()) {
    on<ImageLoaderEvent>((event, emit) async {
      if (event is ImageStart) {
        if (state is! ImageLoaderInitial) {
          emit(ImageLoaderInitial());
        }
        final dio = Dio();
        try {
          final res = await dio.get("https://random.dog/woof.json");
          if (res.statusCode != 200) {
            throw Exception("Failed Request = ${res.statusCode}");
          }

          final dataMap = Map.from(res.data);
          debugPrint(dataMap.toString());

          String url = dataMap["url"];
          final RegExp regExp = RegExp(r"\.mp4|\.webm");
          if (regExp.hasMatch(url)) {
            throw Exception("Not Image File");
          }

          final res1 = await dio.get(url, options: Options(responseType: ResponseType.bytes));

          if (res1.statusCode != 200) {
            throw Exception("Failed Request = ${res.statusCode}");
          }

          image = res1.data;
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
    add(ImageStart());
  }
}
