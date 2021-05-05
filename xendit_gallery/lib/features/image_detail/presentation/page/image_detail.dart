import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:path_provider/path_provider.dart';
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
      return TaskStatus(
          progressStatus: 'Downloading', titleStatus: 'undefined');
    }
  }

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  List<DownloadTask> _tasks = [];
  String _localPath;
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    BlocProvider.of<ImageDetailCubit>(context)
        .callGetImageDetailList(NoParams());
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _prepare();
    super.initState();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          setState(() {
            task.status = status;
            task.progress = progress;
          });
          if (progress == 100) {
            print('deval 100$progress');
            //BlocProvider.of<ImageListCubit>(context).callRefresh(NoParams());
          }
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
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
