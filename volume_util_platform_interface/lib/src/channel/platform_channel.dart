import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:volume_util_platform_interface/volume_util_platform_interface.dart';

import 'method_channel.dart';

abstract class PlatformChannel extends PlatformInterface {
  PlatformChannel() : super(token: _token);

  static PlatformChannel _instance = VolumeMethodChannel();

  static final Object _token = Object();

  static PlatformChannel get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(PlatformChannel instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<double> getVolume(StreamType type);

  Future<bool> setVolume(double volume, StreamType type);

  Future<void> showSystemPanel(bool show);

  Stream<double> onVolumeChange(StreamType type);
}
