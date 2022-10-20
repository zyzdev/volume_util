#import "VolumeUtilIosPlugin.h"
#if __has_include(<volume_util_ios/volume_util_ios-Swift.h>)
#import <volume_util_ios/volume_util_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "volume_util_ios-Swift.h"
#endif

@implementation VolumeUtilIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVolumeUtilIosPlugin registerWithRegistrar:registrar];
}
@end
