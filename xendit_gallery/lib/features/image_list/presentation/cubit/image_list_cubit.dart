import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/core/usecases/usecase.dart';
import 'package:xendit_gallery/features/image_list/data/model/image_model.dart';
import 'package:xendit_gallery/features/image_list/domain/usecases/get_image_list.dart';

part 'image_list_state.dart';

class ImageListCubit extends Cubit<ImageListState> {
  GetImageList getImageList;
  NoParams noParams;
  ImageListCubit({this.getImageList}) : super(ImageListInitial());

  void callGetImageList() async {
    emit(LoadingState());
    final downloadFailedOrSuccess = await getImageList(noParams);
    downloadFailedOrSuccess.fold(
      (l) {
        final failure = l as DownloadFailure;
        emit(LoadingErrorState(error: failure.error));
      },
      (r) => emit(LoadedState(imageList: r)),
    );
  }
}
