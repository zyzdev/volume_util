// ignore_for_file: constant_identifier_names

enum StreamType {
  /// android stream types
  ANDROID_STREAM_ACCESSIBILITY,
  ANDROID_STREAM_ALARM,
  ANDROID_STREAM_DTMF,
  ANDROID_STREAM_MUSIC,
  ANDROID_STREAM_NOTIFICATION,
  ANDROID_STREAM_RING,
  ANDROID_STREAM_SYSTEM,
  ANDROID_STREAM_VOICE_CALL,

  //iOS stream type, one type only
  IOS_STREAM_TYPE,
}

extension ToAndroidStreamType on StreamType {
  int toStreamType() {
    switch (this) {
      case StreamType.ANDROID_STREAM_ACCESSIBILITY:
        return 10;
      case StreamType.ANDROID_STREAM_ALARM:
        return 4;
      case StreamType.ANDROID_STREAM_DTMF:
        return 8;
      case StreamType.ANDROID_STREAM_MUSIC:
        return 3;
      case StreamType.ANDROID_STREAM_NOTIFICATION:
        return 5;
      case StreamType.ANDROID_STREAM_RING:
        return 2;
      case StreamType.ANDROID_STREAM_SYSTEM:
        return 1;
      case StreamType.ANDROID_STREAM_VOICE_CALL:
        return 0;
      default:
        throw (UnsupportedError(
            "StreamType:$name can not convert to android stream type."));
    }
  }
}
