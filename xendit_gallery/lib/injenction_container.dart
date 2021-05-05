import 'package:get_it/get_it.dart';
import 'package:xendit_gallery/features/image_detail/data/datasource/image_detail_datasource.dart';
import 'package:xendit_gallery/features/image_detail/data/repositories/image_detail_repository_impl.dart';
import 'package:xendit_gallery/features/image_detail/domain/repository/image_detail_repository.dart';
import 'package:xendit_gallery/features/image_detail/domain/usecases/get_image_detail.dart';
import 'package:xendit_gallery/features/image_detail/presentation/cubit/image_detail_cubit.dart';
import 'package:xendit_gallery/features/image_list/data/datasource/image_list_remote_datasource.dart';
import 'package:xendit_gallery/features/image_list/data/repositories/image_list_repository_impl.dart';
import 'package:xendit_gallery/features/image_list/domain/repository/image_list_repository.dart';
import 'package:xendit_gallery/features/image_list/domain/usecases/get_image_list.dart';
import 'package:xendit_gallery/features/image_list/presentation/cubit/image_list_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => ImageListCubit(getImageList: sl()));
  sl.registerFactory(() => ImageDetailCubit(getImageDetail: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetImageList(imageListRepository: sl()));
  sl.registerLazySingleton(() => GetImageDetail(imageDetailRepository: sl()));

  // Repositories
  sl.registerLazySingleton<ImageListRepository>(
      () => ImageListRepositoryImpl(imageListRemoteDatasource: sl()));
  sl.registerLazySingleton<ImageDetailRepository>(
      () => ImageDetailRepositoryImpl(imageDetailDatasource: sl()));

  // Datasources
  sl.registerLazySingleton<ImageListRemoteDatasource>(
      () => ImageListRemoteDatasourceImpl());
  sl.registerLazySingleton<ImageDetailDatasource>(
      () => ImageDetailDatasourceImpl());
}
