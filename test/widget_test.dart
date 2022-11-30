// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_test/bloc_test.dart';
import 'package:petparent/bloc/image_loader_bloc.dart';

void main() {
  blocTest<ImageLoaderBloc, ImageLoaderState>(
    'emits [MyState] when MyEvent is added.',
    build: () => ImageLoaderBloc(),
    act: (bloc) => bloc.add(ImageStart()),
    expect: () => <ImageLoaderState>[ImageLoaderInitial()],
  );
}
