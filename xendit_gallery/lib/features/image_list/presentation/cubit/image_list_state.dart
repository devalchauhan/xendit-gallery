part of 'image_list_cubit.dart';

@immutable
abstract class ImageListState {}

class ImageListInitial extends ImageListState {}

class LoadedState extends ImageListState {
  final List<ImageModel> imageList;

  LoadedState({@required this.imageList});

  @override
  List<Object> get props => [imageList];
}

class LoadingErrorState extends ImageListState {
  final String error;
  LoadingErrorState({this.error});
}
