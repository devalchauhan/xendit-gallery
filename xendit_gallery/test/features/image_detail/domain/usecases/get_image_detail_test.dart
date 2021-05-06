import 'package:dartz/dartz.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xendit_gallery/core/usecases/usecase.dart';
import 'package:xendit_gallery/features/image_detail/domain/repository/image_detail_repository.dart';
import 'package:xendit_gallery/features/image_detail/domain/usecases/get_image_detail.dart';

class MockImageDetailRepository extends Mock implements ImageDetailRepository {}

void main() {
  GetImageDetail usecase;
  MockImageDetailRepository mockImageDetailRepository;
  setUp(() {
    mockImageDetailRepository = MockImageDetailRepository();
    usecase = GetImageDetail(imageDetailRepository: mockImageDetailRepository);
  });
  final noParams = NoParams();
  final List<DownloadTask> imageDetail = [];

  test('should get the ImageDetail for local db from the repository', () async {
    //arrange
    when(mockImageDetailRepository.getImageDetail())
        .thenAnswer((_) async => Right(imageDetail));
    //act
    final result = await usecase.call(noParams);
    //assert
    expect(result, Right(imageDetail));
    verify(mockImageDetailRepository.getImageDetail());
    verifyNoMoreInteractions(mockImageDetailRepository);
  });
}
