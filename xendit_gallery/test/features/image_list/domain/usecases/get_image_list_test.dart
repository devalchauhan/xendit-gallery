import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xendit_gallery/features/image_list/data/model/image_model.dart';
import 'package:xendit_gallery/features/image_list/domain/repository/image_list_repository.dart';
import 'package:xendit_gallery/features/image_list/domain/usecases/get_image_list.dart';

class MockImageListRepository extends Mock implements ImageListRepository {}

void main() {
  GetImageList usecase;
  MockImageListRepository mockImageListRepository;
  setUp(() {
    mockImageListRepository = MockImageListRepository();
    usecase = GetImageList(imageListRepository: mockImageListRepository);
  });

  final pageParams = PageParams(page: '1');
  final List<ImageModel> imageList = [];

  test('should get the ImageList for given url from the repository', () async {
    //arrange
    when(mockImageListRepository.getImageList(pageParams))
        .thenAnswer((_) async => Right(imageList));
    //act
    final result = await usecase.call(pageParams);
    //assert
    expect(result, Right(imageList));
    verify(mockImageListRepository.getImageList(pageParams));
    verifyNoMoreInteractions(mockImageListRepository);
  });
}
