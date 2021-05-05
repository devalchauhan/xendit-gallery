import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xendit_gallery/features/image_list/domain/usecases/get_image_list.dart';

part 'image_list_state.dart';

class ImageListCubit extends Cubit<ImageListState> {
  GetImageList getImageList;
  ImageListCubit({this.getImageList}) : super(ImageListInitial());
}
