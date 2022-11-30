import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petparent/bloc/image_loader_bloc.dart';
import 'package:petparent/data/repository/global_repository.dart';
import 'package:petparent/list_screen.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("image");
  runApp(const MaterialApp(home: FirstPage(), debugShowCheckedModeBanner: false));
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0,
      upperBound: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => ImageLoaderBloc(GRepository())..add(ImageStart()),
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Animal Picture"),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.read<ImageLoaderBloc>().add(ImageStart());
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              floatingActionButton: AnimatedBuilder(
                animation: controller,
                builder: (context, snapshot) {
                  return SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
                      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
                    ),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        context.read<ImageLoaderBloc>().add(ImageSave());
                      },
                      label: const Text("Next"),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  );
                },
              ),
              body: SizedBox.expand(
                child: Center(
                  child: BlocConsumer<ImageLoaderBloc, ImageLoaderState>(
                    listener: (context, state) {
                      if (state is ImageLoaderLoaded) {
                        controller.forward();
                      }
                      if (state is ImageLoaderInitial) {
                        if (controller.isCompleted) {
                          controller.reverse();
                        }
                      }
                      if (state is ImageLoaderSaved) {
                        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const ListScreen())));
                      }
                    },
                    buildWhen: (prev, cur) {
                      return cur is! ImageLoaderSaved;
                    },
                    bloc: context.read<ImageLoaderBloc>(),
                    builder: (BuildContext context, state) {
                      if (state is ImageLoaderInitial) {
                        return const CircularProgressIndicator();
                      } else if (state is ImageLoaderLoaded) {
                        debugPrint(state.ans.length.toString());
                        return Image.memory(
                          state.ans,
                          height: MediaQuery.of(context).size.height / 2,
                        );
                      } else {
                        return Text((state as ImageLoaderError).exception);
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
