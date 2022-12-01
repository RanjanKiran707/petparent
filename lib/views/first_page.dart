import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petparent/bloc/image_loader_bloc.dart';
import 'package:petparent/data/repository/global_repository.dart';
import 'package:petparent/views/list_screen.dart';
import 'package:video_player/video_player.dart';

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
        create: (context) => MediaBloc(GRepository())..add(MediaStartE()),
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Animal Picture"),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.read<MediaBloc>().add(MediaStartE());
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
                      onPressed: () async {
                        final ImagePicker imagePicker = ImagePicker();
                        final file = await imagePicker.pickImage(source: ImageSource.gallery);
                        if (file == null) {
                          return;
                        }
                        await Hive.box("image").clear();
                        await Hive.box("image").add(await file.readAsBytes());
                        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const ListScreen())));
                      },
                      label: const Text("Next"),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  );
                },
              ),
              body: SizedBox.expand(
                child: Center(
                  child: BlocConsumer<MediaBloc, MediaState>(
                    listener: (context, state) {
                      if (state is MediaImageLoaded) {
                        controller.forward();
                      }
                      if (state is MediaLoading && controller.isCompleted) {
                        controller.reverse();
                      }
                    },
                    bloc: context.read<MediaBloc>(),
                    builder: (BuildContext context, state) {
                      if (state is MediaLoading) {
                        return const CircularProgressIndicator();
                      }
                      if (state is MediaImageLoaded) {
                        return Image.memory(
                          state.ans,
                          height: MediaQuery.of(context).size.height / 2,
                          fit: BoxFit.fill,
                        );
                      }
                      if (state is MediaError) {
                        return Text((state).exception);
                      }

                      if (state is MediaVideoLoaded) {
                        state.videoPlayerController.play();
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          width: state.videoPlayerController.value.aspectRatio * MediaQuery.of(context).size.height / 2,
                          child: VideoPlayer(
                            state.videoPlayerController,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
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
