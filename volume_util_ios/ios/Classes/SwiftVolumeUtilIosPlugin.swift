import Flutter
import MediaPlayer
import UIKit

public class SwiftVolumeUtilIosPlugin: NSObject, FlutterPlugin {
    private let DEBUG = false

    private var methodChannel: FlutterMethodChannel
    private let mpVolumeView = MPVolumeView()
    private var volumeSlideView: UISlider
    private let audioSession = AVAudioSession.sharedInstance()
    private var showSystemPanel = true
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "volume_util", binaryMessenger: registrar.messenger())
        let instance = SwiftVolumeUtilIosPlugin(methodChannel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.listenVolumeChange()
    }


    init(
        methodChannel: FlutterMethodChannel
    ) {
        self.methodChannel = methodChannel
        self.volumeSlideView = mpVolumeView.subviews.first as! UISlider
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method: String = call.method
        let args = call.arguments

        switch method {
            case "volume#get":
                result(getVolume())
            case "volume#set":
                result(setVolume(args))
            case "showSystemPanel#set":
                showSystemPanel(args)
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
        }
    }

    private func getVolume() -> Float {
        return volumeSlideView.value
    }

    private func setVolume(_ args: Any?) -> Bool {
        let volume = Float(args as! CGFloat)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            self.volumeSlideView.value = volume
        }
        return true
    }

    private func showSystemPanel(_ args: Any?) {
        let showSystemPanel = Bool(args as? Bool ?? true)
        if showSystemPanel != self.showSystemPanel {
            if showSystemPanel {
                mpVolumeView.removeFromSuperview()
            } else {
                mpVolumeView.frame = CGRectMake(-100, -100, 50, 50)
                if let app = UIApplication.shared.delegate as UIApplicationDelegate?, let window = app.window {
                    window?.addSubview(mpVolumeView)
                }
            }
            self.showSystemPanel = showSystemPanel
        }
    }
    
    func listenVolumeChange() {
        do {
            try audioSession.setActive(true)
            audioSession.addObserver(self, forKeyPath: "outputVolume",
                                     options: NSKeyValueObservingOptions.new, context: nil)
        } catch {
            debug("Error")
        }
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            methodChannel.invokeMethod("volume#onChange", arguments: audioSession.outputVolume)
        }
    }
}

extension SwiftVolumeUtilIosPlugin {
    private func toS(_ arg: Any?) -> String {
        return arg != nil ? String(describing: arg) : ""
    }

    private func debug(_ log: Any?, _ debug: Bool = false) {
        if !DEBUG, !debug { return }
        methodChannel.invokeMethod("print#log", arguments: "iOS volume_util: \(log is String ? log as! String : toS(log))")
    }
}
