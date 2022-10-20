package zyz.flutter.plugin.volume_util_android


import android.app.Activity
import android.content.Context
import android.database.ContentObserver
import android.media.AudioManager
import android.media.AudioManager.*
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.util.SparseArray
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** VolumeUtilAndroidPlugin */
class VolumeUtilAndroidPlugin() : FlutterPlugin, MethodCallHandler, ActivityAware {

    private val dTag: String = javaClass.simpleName

    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context
    private lateinit var activity: Activity
    private var showSystemPanel = true
    private val audioManager: AudioManager by lazy {
        activity.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    }

    private fun getMaxVolume(streamType: Int): Float {
        return audioManager.getStreamMaxVolume(streamType).toFloat()
    }

    companion object {
        // last volume of each stream type
        val preVolumes = SparseArray<Float>()
        val streamTypes = arrayListOf(
            STREAM_ACCESSIBILITY,
            STREAM_ALARM,
            STREAM_DTMF,
            STREAM_MUSIC,
            STREAM_NOTIFICATION,
            STREAM_RING,
            STREAM_SYSTEM,
            STREAM_VOICE_CALL,
        )
    }

    private val volumeObservable: ContentObserver by lazy {
        object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean) {
                super.onChange(selfChange)
                streamTypes.forEach { streamType ->
                    val volume = getVolume(streamType)
                    val preVolume = preVolumes[streamType]
                    if (preVolume != volume) {
                        val data = mapOf(
                            "streamType" to streamType, "volume" to volume
                        )
                        channel.invokeMethod(
                            "volume#onChange", data
                        )
                        preVolumes[streamType] = volume
                        //Log.d(dTag, "onChange:$data")
                    }
                }
            }
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "volume_util")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        init()
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {
        activity.contentResolver.unregisterContentObserver(volumeObservable)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val method = call.method
        val args = call.arguments
        //printLog("onMethodCall, method:$method, args:$args")
        when (method) {
            "volume#get" -> result.success(getVolume(args as Int))
            "volume#set" -> result.success(setVolume((args as Map<String, Any>)))
            "showSystemPanel#set" ->{
                showSystemPanel(args as Boolean)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun init() {
        audioManager
        activity.contentResolver.registerContentObserver(
            android.provider.Settings.System.CONTENT_URI,
            true,
            volumeObservable
        )
        streamTypes.forEach { streamType ->
            val volume = getVolume(streamType)
            preVolumes[streamType] = volume
            //Log.d(dTag, "onChange:$data")
        }
    }

    private fun getVolume(streamType: Int): Float {
        return audioManager.getStreamVolume(streamType) / getMaxVolume(streamType)
    }

    private fun setVolume(args: Map<String, Any>): Boolean {
        val volume: Double = args["volume"] as Double
        val streamType: Int = args["streamType"] as Int
        val settingVolume = getMaxVolume(streamType) * volume
        audioManager.setStreamVolume(
            streamType,
            settingVolume.toInt(),
            if (showSystemPanel) FLAG_SHOW_UI else 0
        )
        return true
    }

    private fun showSystemPanel(showSystemPanel: Boolean) {
        this.showSystemPanel = showSystemPanel
    }

    private fun printLog(info: Any) {
        channel.invokeMethod("print#log", "$dTag, $info")
    }
}
