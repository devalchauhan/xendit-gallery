part of 'image_detail_cubit.dart';

abstract class ImageDetailState {
  const ImageDetailState();
}

class ImageDetailInitial extends ImageDetailState {}

class LoadedState extends ImageDetailState {
  final List<DownloadTask> imageDetailList;

  LoadedState({@required this.imageDetailList});
  @override
  List<Object> get props => [imageDetailList];
}

class LoadingErrorState extends ImageDetailState {
  final String error;
  LoadingErrorState({this.error});
}
