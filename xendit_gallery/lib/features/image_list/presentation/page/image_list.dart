import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xendit_gallery/constants/colors.dart';
import 'package:xendit_gallery/constants/strings.dart';
import 'package:xendit_gallery/features/image_list/domain/usecases/get_image_list.dart';
import 'package:xendit_gallery/features/image_list/presentation/cubit/image_list_cubit.dart';
import 'package:shimmer/shimmer.dart';

class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  ScrollController controller;
  int pageIndex = 1;
  @override
  void initState() {
    BlocProvider.of<ImageListCubit>(context)
        .callGetImageList(PageParams(page: pageIndex.toString()));
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.atEdge) {
      if (controller.position.pixels == 0) {
        // You're at the top.
      } else {
        pageIndex++;
        BlocProvider.of<ImageListCubit>(context)
            .callGetImageList(PageParams(page: pageIndex.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
        actions: [
          IconButton(
            icon: Icon(Icons.download_sharp),
            onPressed: () {
              Navigator.pushNamed(context, IMAGE_DETAIL);
            },
          ),
        ],
      ),
      body: BlocListener<ImageListCubit, ImageListState>(
        listener: (context, state) {},
        child: BlocBuilder<ImageListCubit, ImageListState>(
          builder: (BuildContext context, ImageListState imageListState) {
            if (imageListState is ImageListInitial) {
              return Center(child: CircularProgressIndicator());
            }
            if (imageListState is LoadedState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  controller: controller,
                  itemCount: imageListState.imageList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                                imageListState.imageList[index].previewURL,
                            placeholder: (context, url) => Shimmer(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, IMAGE_DETAIL);
                      },
                    );
                  },
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
