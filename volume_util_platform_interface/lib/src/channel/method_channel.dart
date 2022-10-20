import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:volume_util_platform_interface/volume_util_platform_interface.dart';

class VolumeMethodChannel extends PlatformChannel {
  static const MethodChannel _channel = MethodChannel('volume_util');

  final Map<StreamType, StreamController<double>>
      _volumeChangeStreamTypeController = {};

  VolumeMethodChannel() : super() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  Future<double> getVolume(StreamType type) async {
    return (await _channel.invokeMethod<double>(
        "volume#get", Platform.isAndroid ? type.toStreamType() : null))!;
  }

  @override
  Future<bool> setVolume(double volume, StreamType type) async {
    return await _channel.invokeMethod(
        "volume#set",
        Platform.isAndroid
            ? {
                "volume": volume,
                "streamType": type.toStreamType(),
              }
            : volume);
  }

  @override
  Future<void> showSystemPanel(bool show) async {
    return await _channel.invokeMethod("showSystemPanel#set", show);
  }

  @override
  Stream<double> onVolumeChange(StreamType type) {
    _volumeChangeStreamTypeController[type] ??=
        StreamController<double>.broadcast();
    return _volumeChangeStreamTypeController[type]!.stream;
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    String method = call.method;
    final args = call.arguments;
    switch (method) {
      case "print#log":
        debugPrint("print#log, info:$args");
        break;
      case "volume#onChange":
        StreamType streamType;
        double volume;
        if (Platform.isAndroid) {
          streamType = _fromNativeStreamType(args['streamType'] as int);
          volume = args['volume'];
        } else {
          streamType = StreamType.IOS_STREAM_TYPE;
          volume = args;
        }
        _volumeChangeStreamTypeController[streamType]!.add(volume);
        debugPrint("streamType:${streamType.name}, volume:$volume");
        break;
      default:
        throw MissingPluginException();
    }
  }

  StreamType _fromNativeStreamType(int streamType) {
    if (Platform.isIOS) return StreamType.IOS_STREAM_TYPE;
    switch (streamType) {
      case 10:
        return StreamType.ANDROID_STREAM_ACCESSIBILITY;
      case 4:
        return StreamType.ANDROID_STREAM_ALARM;
      case 8:
        return StreamType.ANDROID_STREAM_DTMF;
      case 3:
        return StreamType.ANDROID_STREAM_MUSIC;
      case 5:
        return StreamType.ANDROID_STREAM_NOTIFICATION;
      case 2:
        return StreamType.ANDROID_STREAM_RING;
      case 1:
        return StreamType.ANDROID_STREAM_SYSTEM;
      case 0:
        return StreamType.ANDROID_STREAM_VOICE_CALL;
      default:
        throw (UnsupportedError(
            "streamType:$streamType can not convert to StreamType."));
    }
  }
}
