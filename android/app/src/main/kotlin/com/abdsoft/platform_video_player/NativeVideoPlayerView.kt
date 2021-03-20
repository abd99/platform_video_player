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

class NativeVideoPlayerView internal constructor(context: Context, messenger: BinaryMessenger, id: Int) : PlatformView, MethodChannel.MethodCallHandler {
    private val view: View
    private val methodChannel: MethodChannel
    lateinit var player:SimpleExoPlayer
    lateinit var playerView:PlayerView
    private var playWhenReady = false
    private var currentWindow = 0
    private var playbackPosition: Long = 0

    override fun getView(): View {
        return view
    }

    init {
        view = LayoutInflater.from(context).inflate(R.layout.native_widget, null)

        methodChannel = MethodChannel(messenger, "PlatformVideoPlayer.VIDEO_PLAYER_$id")
        methodChannel.setMethodCallHandler(this)

        if (Util.SDK_INT >= 24) {
            initializePlayer(context)
        }
    }

    private fun initializePlayer(context: Context){
        playerView = view.video_view
        player = SimpleExoPlayer.Builder(context).build()
        playerView.player = player

        val mediaItem = MediaItem.fromUri(context.getString(R.string.media_url_mp4))
//        val mediaItem = MediaItem.fromUri("https://r1---sn-cvh76nes.googlevideo.com/videoplayback?expire=1616109255&ei=Z4pTYPGEH4Tc4-EPhL2G0A0&ip=159.192.75.89&id=o-AAQSX-r6jDBQ3dLeW1LeUXH_PygnjwwrVtT22IHtQmqe&itag=22&source=youtube&requiressl=yes&vprv=1&mime=video%2Fmp4&ns=f-ek2oMtFzILf5M72MV0b8YF&cnr=14&ratebypass=yes&dur=1502.888&lmt=1612100566475629&fvip=1&fexp=24001373,24007246&c=WEB&txp=5532432&n=RlaQPMsrM0alNaktNE&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRQIhANpSiQChSPm_-XwnK_RF_v_faYALSc6Og6iGmdF7y24tAiBpKdk_sdbwq0Zn8ERWkMuxKfJRfZlYSzXUY_YM1gTP4Q%3D%3D&title=Tesla%20Model%203%20Performance%202021%20review%3A%20see%20how%20quick%20it%20is%200-60mph...%20And%20easy%20to%20drift!&rm=sn-j5u-iqtl7e,sn-npoll7e&req_id=83a01c3966f2a3ee&redirect_counter=2&cms_redirect=yes&ipbypass=yes&mh=_q&mip=45.113.249.189&mm=29&mn=sn-cvh76nes&ms=rdu&mt=1616087578&mv=m&mvi=1&pl=24&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRgIhAO3AOiVjxtocC6gKAewNbnJq5C7OXw-3V4n20BQwL93yAiEApL75YrvsAe98umddAi0JpS9XnIcMGXUm43NaPesgwV8%3D")
        player.setMediaItem(mediaItem)

        player.playWhenReady = playWhenReady
//        player.seekTo(currentWindow, playbackPosition)
        player.prepare()

    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "ping" -> ping(methodCall, result)
            "pause" -> pause(methodCall, result)
            "initialize" -> initialize(methodCall, result)
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

    private fun initialize(methodCall: MethodCall, result: Result) {
        Log.i("NativeVideoPlayer.kt", "initialize called.");


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
