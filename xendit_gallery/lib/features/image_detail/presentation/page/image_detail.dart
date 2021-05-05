import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xendit_gallery/core/usecases/usecase.dart';
import 'package:xendit_gallery/features/image_detail/presentation/cubit/image_detail_cubit.dart';
import 'package:xendit_gallery/features/image_detail/presentation/widgets/image_detail_widgets.dart';

class ImageDetail extends StatefulWidget {
  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    BlocProvider.of<ImageDetailCubit>(context)
        .callGetImageDetailList(NoParams());
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

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

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    // _tasks.addAll(_images
    //     .map((image) => _TaskInfo(name: image['name'], link: image['link'])));
    //
    // _items.add(_ItemHolder(name: 'Images'));
    // for (int i = count; i < _tasks.length; i++) {
    //   _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
    //   count++;
    // }

    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
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
      body: BlocListener<ImageDetailCubit, ImageDetailState>(
        listener: (context, state) {},
        child: BlocBuilder<ImageDetailCubit, ImageDetailState>(
          builder: (BuildContext context, ImageDetailState imageListState) {
            if (imageListState is ImageDetailInitial) {
              return Center(child: CircularProgressIndicator());
            }
            if (imageListState is LoadedState) {
              List<DownloadTask> tasks = imageListState.imageDetailList;
              return tasks.length > 0
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GroupedListView<DownloadTask, String>(
                        elements: tasks,
                        groupBy: (element) => element.status.toString(),
                        groupSeparatorBuilder: (String groupByValue) =>
                            SectionHeader(
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
                  : Container();
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}
