import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';

class Downloading {
  Function _callBack;
  Function _callBackForList;
  Downloading._();
  static final Downloading downloading = Downloading._();
  init() {
    bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  ReceivePort _port = ReceivePort();
  void setCallBack(callBack) {
    _callBack = callBack;
  }

  void setCallBackForList(callBack) {
    _callBackForList = callBack;
  }

  void bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      unbindBackgroundIsolate();
      bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (_callBack != null) {
        _callBack(data);
      }
      if (_callBackForList != null) {
        _callBackForList(data);
      }
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
}
