// ignore_for_file: constant_identifier_names

enum StreamType {
  ANDROID_STREAM_ACCESSIBILITY, /// android stream type, map to [STREAM_ACCESSIBILITY](https://developer.android.com/reference/android/media/AudioManager#STREAM_ACCESSIBILITY)
  ANDROID_STREAM_ALARM,         /// android stream type, map to [STREAM_ALARM](https://developer.android.com/reference/android/media/AudioManager#STREAM_ALARM)
  ANDROID_STREAM_DTMF,          /// android stream type, map to [STREAM_DTMF](https://developer.android.com/reference/android/media/AudioManager#STREAM_DTMF)
  ANDROID_STREAM_MUSIC,         /// android stream type, map to [STREAM_MUSIC](https://developer.android.com/reference/android/media/AudioManager#STREAM_MUSIC)
  ANDROID_STREAM_NOTIFICATION,  /// android stream type, map to [STREAM_NOTIFICATION](https://developer.android.com/reference/android/media/AudioManager#STREAM_NOTIFICATION)
  ANDROID_STREAM_RING,          /// android stream type, map to [STREAM_RING](https://developer.android.com/reference/android/media/AudioManager#STREAM_RING)
  ANDROID_STREAM_SYSTEM,        /// android stream type, map to [STREAM_SYSTEM](https://developer.android.com/reference/android/media/AudioManager#STREAM_SYSTEM)
  ANDROID_STREAM_VOICE_CALL,    /// android stream type, map to [STREAM_VOICE_CALL](https://developer.android.com/reference/android/media/AudioManager#STREAM_VOICE_CALL)

  IOS_STREAM_TYPE,              ///iOS stream type, one type only, just for platform distinction
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
