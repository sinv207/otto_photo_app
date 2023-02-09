import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:otto_photo_app/models/photo_data.dart';
import 'package:otto_photo_app/repositories/photos_repository.dart';

import '../../configs/enums.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final PhotosRepository repository;

  PhotosBloc({required this.repository}) : super(const PhotosState.initial()) {
    on<PhotosFetched>(_photosFetched);
  }

  Future<FutureOr<void>> _photosFetched(
      PhotosFetched event, Emitter<PhotosState> emit) async {
    emit(state.copyWith(
      status: BlocStatus.loading,
    ));

    List<PhotoData> photos = await repository.fetchPhotos();
    emit(state.copyWith(
      status: BlocStatus.success,
      photos: photos,
    ));
  }
}
