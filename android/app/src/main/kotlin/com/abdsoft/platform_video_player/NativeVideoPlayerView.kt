package com.abdsoft.platform_video_player

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.SimpleExoPlayer
import com.google.android.exoplayer2.ui.PlayerView
import com.google.android.exoplayer2.util.Util
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.platform.PlatformView
import kotlinx.android.synthetic.main.native_widget.view.*

class NativeVideoPlayerView internal constructor(context: Context, messenger: BinaryMessenger, id: Int, creationParams: Map<String?, Any?>?) : PlatformView, MethodChannel.MethodCallHandler {
    private val view: View
    private val methodChannel: MethodChannel
    lateinit var player:SimpleExoPlayer
    lateinit var playerView:PlayerView
    private var playWhenReady = false
    private var currentWindow = 0
    private var playbackPosition: Long = 0
    private val url:String

    override fun getView(): View {
        return view
    }

    init {
        view = LayoutInflater.from(context).inflate(R.layout.native_widget, null)

        methodChannel = MethodChannel(messenger, "PlatformVideoPlayer.VIDEO_PLAYER_$id")
        methodChannel.setMethodCallHandler(this)
        url = creationParams?.get("url").toString();

        if (Util.SDK_INT >= 24) {
            initializePlayer(context)
        }
    }

    private fun initializePlayer(context: Context){
        playerView = view.video_view
        player = SimpleExoPlayer.Builder(context).build()
        playerView.player = player

        val mediaItem = MediaItem.fromUri(url)
        player.setMediaItem(mediaItem)

        player.playWhenReady = playWhenReady
//        player.seekTo(currentWindow, playbackPosition)
        player.prepare()

    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "ping" -> ping(methodCall, result)
            "pause" -> pause(methodCall, result)
            else -> result.notImplemented()
        }
    }

    private fun ping(methodCall: MethodCall, result: Result) {
        result.success(null)
    }

    private fun pause(methodCall: MethodCall, result: Result) {
        Log.i("NativeVideoPlayer.kt", "pause called.");
        player.pause()
        result.success(true)
    }

    override fun dispose() {
        if (Util.SDK_INT >= 24) {
            releasePlayer()
        }
    }

    private fun releasePlayer() {
        if (player != null) {
            playWhenReady = player.playWhenReady
            playbackPosition = player.currentPosition
            currentWindow = player.currentWindowIndex
            player.release()
        }
    }

    override fun onFlutterViewDetached() {
//        super.onFlutterViewDetached()

            releasePlayer();

    }
}
