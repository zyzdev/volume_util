import 'dart:async';
import 'dart:io';

import 'package:volume_util_platform_interface/volume_util_platform_interface.dart';

class VolumeUtil {
  late final StreamType _streamType;
  late final StreamType defStreamType = Platform.isAndroid
      ? StreamType.ANDROID_STREAM_MUSIC
      : StreamType.IOS_STREAM_TYPE;

  VolumeUtil([StreamType? streamType]) {
    if (streamType != null) {
      if (Platform.isAndroid) {
        if (streamType != StreamType.IOS_STREAM_TYPE) {
          _streamType = streamType;
          return;
        }
      }
    }
    _streamType = defStreamType;
  }

  PlatformChannel get _platformChannel => PlatformChannel.instance;

  Future<double> getVolume() async {
    return _platformChannel.getVolume(_streamType);
  }

  Future<bool> setVolume(double percent) async {
    return _platformChannel.setVolume(percent, _streamType);
  }

  Future<void> showSystemPanel(bool show) {
    return _platformChannel.showSystemPanel(show);
  }

  Stream<double> getVolumeChangeStream() =>
      _platformChannel.onVolumeChange(_streamType);
}
