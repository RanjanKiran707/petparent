import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:petparent/data/repository/global_repository.dart';
import 'package:video_player/video_player.dart';

part 'image_loader_event.dart';
part 'image_loader_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final IRepository gRepository;
  MediaBloc(this.gRepository) : super(MediaLoading()) {
    on<MediaEvent>((event, emit) async {
      if (event is MediaStartE) {
        if (state is! MediaLoading) {
          emit(MediaLoading());
        }
        if (state is MediaVideoLoaded) {
          (state as MediaVideoLoaded).videoPlayerController.dispose();
        }
        try {
          final media = await gRepository.getMedia();
          if (media[0] == Type.image) {
            emit(MediaImageLoaded(media[1]));
            return;
          }
          final vidController = VideoPlayerController.network(media[1]);
          await vidController.initialize();
          emit(MediaVideoLoaded(vidController));
        } catch (e) {
          emit(MediaError(e.toString()));
          debugPrintStack();
        }
      }
    });
  }
}
