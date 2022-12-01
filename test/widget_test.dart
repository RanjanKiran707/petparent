// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petparent/bloc/image_loader_bloc.dart';
import 'package:petparent/bloc/list_loader_bloc.dart';
import 'package:petparent/data/repository/global_repository.dart';

class MockRepo implements IRepository {
  @override
  Future<List> getMedia() {
    return Future.value(List.from([
      Type.image,
      Uint8List.fromList([1, 2])
    ]));
  }

  @override
  Future<List> getList() {
    return Future.value(["", ""]);
  }
}

void main() {
  late IRepository gRepository;
  setUp(() {
    gRepository = MockRepo();
  });
  blocTest<MediaBloc, MediaState>(
    'Image start event complete with image loaded or error state',
    build: () => MediaBloc(gRepository),
    act: (bloc) => bloc.add(MediaStartE()),
    expect: () => <MediaState>[
      MediaImageLoaded(Uint8List.fromList([1, 2]))
    ],
  );

  blocTest<ListLoaderBloc, ListLoaderState>(
    'List Loader Bloc test ',
    build: () => ListLoaderBloc(gRepository),
    act: (bloc) {
      bloc.add(ListLoaderStart());
      bloc.add(ListLoaderStart());
    },
    expect: () => <ListLoaderState>[
      ListLoaderDone(const ["", ""])
    ],
  );
}
