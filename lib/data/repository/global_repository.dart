import 'dart:typed_data';

import 'package:dio/dio.dart';

abstract class IRepository {
  Future<Uint8List> getImage();

  Future<List> getList();
}

class GRepository implements IRepository {
  final dio = Dio();
  @override
  Future<Uint8List> getImage() async {
    final res = await dio.get("https://random.dog/woof.json");
    if (res.statusCode != 200) {
      throw Exception("Failed Request = ${res.statusCode}");
    }

    final dataMap = Map.from(res.data);

    String url = dataMap["url"];
    final RegExp regExp = RegExp(r"\.mp4|\.webm");
    if (regExp.hasMatch(url)) {
      throw Exception("Not Image File");
    }

    final res1 = await dio.get(url, options: Options(responseType: ResponseType.bytes));

    if (res1.statusCode != 200) {
      throw Exception("Failed Request = ${res.statusCode}");
    }
    return res1.data;
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
