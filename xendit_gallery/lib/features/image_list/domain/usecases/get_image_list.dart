import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/core/usecases/usecase.dart';
import 'package:xendit_gallery/features/image_list/domain/entities/image.dart';
import 'package:xendit_gallery/features/image_list/domain/repository/image_list_repository.dart';

class GetImageList implements UseCase<List<NetImage>, PageParams> {
  final ImageListRepository imageListRepository;
  GetImageList({@required this.imageListRepository});

  @override
  Future<Either<Failure, List<NetImage>>> call(PageParams params) async {
    return await imageListRepository.getImageList(params);
  }
}

class PageParams extends Equatable {
  final String page;

  PageParams({@required this.page});

  @override
  List<Object> get props => [page];
}
