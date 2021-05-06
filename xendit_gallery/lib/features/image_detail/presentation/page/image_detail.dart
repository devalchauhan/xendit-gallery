import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xendit_gallery/core/downloading/download_service.dart';
import 'package:xendit_gallery/core/usecases/usecase.dart';
import 'package:xendit_gallery/features/image_detail/presentation/cubit/image_detail_cubit.dart';
import 'package:xendit_gallery/features/image_detail/presentation/widgets/image_detail_widgets.dart';
import 'package:xendit_gallery/features/image_list/presentation/cubit/image_list_cubit.dart';

class ImageDetail extends StatefulWidget {
  static TaskStatus getStatus(int downloadTaskStatus) {
    if (downloadTaskStatus == 3) {
      return TaskStatus(
          progressStatus: 'Downloaded', titleStatus: 'Downloaded');
    } else if (downloadTaskStatus == 1) {
      return TaskStatus(progressStatus: 'Downloading', titleStatus: 'Pending');
    } else if (downloadTaskStatus == 2) {
      return TaskStatus(
          progressStatus: 'Downloading', titleStatus: 'Downloading');
    } else {
      return TaskStatus(progressStatus: 'Downloading', titleStatus: 'pending');
    }
  }

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  List<DownloadTask> _tasks = [];
  String _localPath;
  @override
  void initState() {
    BlocProvider.of<ImageDetailCubit>(context)
        .callGetImageDetailList(NoParams());
    Downloading.downloading.setCallBack((data) {
      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == data[0]);
        if (task != null) {
          setState(() {
            task.status = data[1];
            task.progress = data[2];
          });
          if (data[2] == 100) {
            BlocProvider.of<ImageListCubit>(context).callRefresh(NoParams());
          }
        }
      }
    });
    _prepare();
    super.initState();
  }

  @override
  void dispose() {
    //Downloading.downloading.unbindBackgroundIsolate();
    super.dispose();
  }

  Future<Null> _prepare() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    final tasks = await FlutterDownloader.loadTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<String> _findLocalPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _tasks.length > 0
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: GroupedListView<DownloadTask, String>(
                elements: _tasks,
                groupBy: (element) =>
                    ImageDetail.getStatus(element.status.value).progressStatus,
                groupSeparatorBuilder: (String groupByValue) => SectionHeader(
                  groupByValue: groupByValue,
                ),
                separator: SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, dynamic element) => SectionRow(
                  element: element,
                ),
                // optional
              ),
            )
          : Container(),
    );
  }
}

class TaskStatus {
  String progressStatus;
  String titleStatus;
  TaskStatus({@required this.progressStatus, @required this.titleStatus});
}
