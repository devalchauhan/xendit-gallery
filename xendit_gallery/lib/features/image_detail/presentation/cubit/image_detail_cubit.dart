import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xendit_gallery/features/image_detail/domain/usecases/get_image_detail.dart';

part 'image_detail_state.dart';

class ImageDetailCubit extends Cubit<ImageDetailState> {
  GetImageDetail getImageDetail;
  ImageDetailCubit({this.getImageDetail}) : super(ImageDetailInitial());
}
