# volume_util

A flutter plugin to config and monitor volume.

## Getting Started

### Get Volume
```dart
final VolumeUtil volumeUtil = VolumeUtil();
double volume = await volumeUtil.getVolume();
```

### Set Volume
```dart
double volume = 0.5;
final VolumeUtil volumeUtil = VolumeUtil();
bool success = await volumeUtil.setVolume(volume);
```
### Listen Volume Change
```dart
final VolumeUtil volumeUtil = VolumeUtil();
StreamSubscription ss = volumeUtil.getVolumeChangeStream().listen((volume) {
  debugPrint("volume:$volume");
});

...

ss.cancel();
```