import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum Type {
  image,
  video,
}

abstract class IRepository {
  Future<List> getMedia();

  Future<List> getList();
}

class GRepository implements IRepository {
  final dio = Dio();
  @override
  Future<List> getMedia() async {
    final res = await dio.get("https://random.dog/woof.json");
    if (res.statusCode != 200) {
      throw Exception("Failed Request = ${res.statusCode}");
    }

    final dataMap = Map.from(res.data);

    String url = dataMap["url"];
    debugPrint(url);
    late Type type;
    final RegExp regExp = RegExp(r"\.mp4|\.webm");

    type = regExp.hasMatch(url) ? Type.video : Type.image;

    if (type == Type.image) {
      final res1 = await dio.get(url, options: Options(responseType: ResponseType.bytes));

      if (res1.statusCode != 200) {
        throw Exception("Failed Request = ${res.statusCode}");
      }
      return [type, res1.data];
    }

    return [type, url];
  }

  @override
  Future<List> getList() async {
    final res = await dio.get("http://jsonplaceholder.typicode.com/posts");
    if (res.statusCode != 200) {
      throw Exception(res.statusMessage);
    }
    return res.data;
  }
}
