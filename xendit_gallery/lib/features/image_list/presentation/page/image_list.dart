import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xendit_gallery/constants/colors.dart';
import 'package:xendit_gallery/constants/strings.dart';
import 'package:xendit_gallery/core/downloading/download_service.dart';
import 'package:xendit_gallery/core/usecases/usecase.dart';
import 'package:xendit_gallery/features/image_list/data/model/image_model.dart';
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
  List<DownloadTask> tasks = [];
  List<ImageModel> _tasks = [];
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    Downloading.downloading.init();
    BlocProvider.of<ImageListCubit>(context)
        .callGetImageList(PageParams(page: pageIndex.toString()));
    controller = new ScrollController()..addListener(_scrollListener);
    getLocalImages();
    _checkPermission();
    Downloading.downloading.setCallBackForList((data) {
      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == data[0]);
        if (task != null) {
          setState(() {
            task.percentage = double.parse(data[2].toString());
          });
          if (data[2] == 100) {
            BlocProvider.of<ImageListCubit>(context).callRefresh(NoParams());
          }
        }
      }
    });
    super.initState();
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void getLocalImages() async {
    tasks = await FlutterDownloader.loadTasks();
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

  CheckDownloadStatus isDownloaded(String id) {
    dynamic condition = tasks.singleWhere((element) {
      final headers = jsonDecode(element.headers);
      return headers['imageId'] == id;
    }, orElse: () => null);
    if ((condition) != null) {
      return CheckDownloadStatus(
          isDownloaded: true,
          filePath: condition.savedDir + '/' + condition.filename);
    } else {
      return CheckDownloadStatus(isDownloaded: false, filePath: '');
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
              _tasks = imageListState.imageList;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  controller: controller,
                  itemCount: _tasks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    ImageModel imageModel = _tasks[index];
                    return Stack(
                      children: [
                        GestureDetector(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 8,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              child: CachedNetworkImage(
                                height: 200,
                                width: 200,
                                fit: BoxFit.fill,
                                imageUrl: imageModel.previewURL,
                                placeholder: (context, url) => Shimmer(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          onTap: () async {
                            if (isDownloaded(imageModel.id.toString())
                                .isDownloaded) {
                              Navigator.pushNamed(context, IMAGE_BROWSER,
                                  arguments:
                                      isDownloaded(imageModel.id.toString())
                                          .filePath);
                            } else {
                              Directory appDocDir =
                                  await getApplicationDocumentsDirectory();
                              String appDocPath = appDocDir.path;
                              final taskId = await FlutterDownloader.enqueue(
                                url: imageModel.largeImageURL,
                                /*url:
                                    'http://barbra-coco.dyndns.org/student/learning_android_studio.pdf',*/
                                headers: {
                                  "previewURL": imageModel.previewURL,
                                  "imageId": imageModel.id.toString()
                                },
                                savedDir: appDocPath,
                                showNotification: false,
                                openFileFromNotification: false,
                              );
                              imageModel.taskId = taskId;
                            }
                          },
                        ),
                        Visibility(
                          visible: (isDownloaded(imageModel.id.toString())
                                      .isDownloaded ||
                                  imageModel.percentage == 100)
                              ? true
                              : false,
                          child: Center(
                            child: IgnorePointer(
                              child: CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                child: Icon(
                                  Icons.download_done_outlined,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (imageModel.percentage == 100 ||
                                  imageModel.percentage == 0)
                              ? false
                              : true,
                          child: Center(
                            child: CircularPercentIndicator(
                              radius: 60.0,
                              lineWidth: 5.0,
                              percent: imageModel.percentage / 100,
                              progressColor: Colors.orange,
                            ),
                          ),
                        ),
                      ],
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

class CheckDownloadStatus {
  bool isDownloaded;
  String filePath;
  CheckDownloadStatus({
    @required this.isDownloaded,
    @required this.filePath,
  });
}
