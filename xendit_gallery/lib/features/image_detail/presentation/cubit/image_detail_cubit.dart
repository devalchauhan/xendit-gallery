import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/core/usecases/usecase.dart';
import 'package:xendit_gallery/features/image_detail/domain/usecases/get_image_detail.dart';

part 'image_detail_state.dart';

class ImageDetailCubit extends Cubit<ImageDetailState> {
  GetImageDetail getImageDetail;
  ImageDetailCubit({this.getImageDetail}) : super(ImageDetailInitial());

  void callGetImageDetailList(NoParams params) async {
    final downloadFailedOrSuccess = await getImageDetail(params);
    downloadFailedOrSuccess.fold(
      (l) {
        final failure = l as DownloadFailure;
        emit(LoadingErrorState(error: failure.error));
      },
      (r) => emit(LoadedState(imageDetailList: r)),
    );
  }
}
