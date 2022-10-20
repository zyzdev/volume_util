import 'dart:async';
import 'dart:io';

import 'package:volume_util_platform_interface/volume_util_platform_interface.dart';

class VolumeUtil {
  late final StreamType _streamType;
  late final StreamType defStreamType = Platform.isAndroid
      ? StreamType.ANDROID_STREAM_MUSIC
      : StreamType.IOS_STREAM_TYPE;

  /// [streamType], the volume stream type you cared, it is work for `android` only.
  /// see [StreamType] for more detail.
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

  /// return current volume
  /// range 0 <= volume <= 1
  /// `Android`, volume is int level, so the volume is a discontinuous double value.
  Future<double> getVolume() async {
    return _platformChannel.getVolume(_streamType);
  }

  /// range 0 <= volume <= 1
  /// return true means success, otherwise false
  Future<bool> setVolume(double volume) async {
    assert(volume >= 0 && volume <= 1);
    return _platformChannel.setVolume(volume, _streamType);
  }

  /// show or hide system panel
  Future<void> showSystemPanel(bool show) {
    return _platformChannel.showSystemPanel(show);
  }

  /// volume listener and return brightness was changed
  /// range 0 <= brightness <= 1
  Stream<double> getVolumeChangeStream() =>
      _platformChannel.onVolumeChange(_streamType);
}
