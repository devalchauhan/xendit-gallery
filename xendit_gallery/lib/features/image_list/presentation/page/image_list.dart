import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xendit_gallery/features/image_list/presentation/cubit/image_list_cubit.dart';
import 'package:shimmer/shimmer.dart';

class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  @override
  void initState() {
    BlocProvider.of<ImageListCubit>(context).callGetImageList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
      ),
      body: BlocListener<ImageListCubit, ImageListState>(
        listener: (context, state) {
          if (state is ImageListInitial) {}
        },
        child: BlocBuilder<ImageListCubit, ImageListState>(
          builder: (BuildContext context, ImageListState imageListState) {
            if (imageListState is LoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            if (imageListState is LoadedState) {
              return GridView.builder(
                itemCount: imageListState.imageList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
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
                          imageUrl: imageListState.imageList[index].previewURL,
                          placeholder: (context, url) => Shimmer(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    onTap: () {},
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
