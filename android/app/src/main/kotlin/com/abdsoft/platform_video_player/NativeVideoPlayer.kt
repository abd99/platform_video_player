package com.abdsoft.platform_video_player

import io.flutter.embedding.engine.FlutterEngine


object NativeVideoPlayer{
    fun registerWith(engine: FlutterEngine) {
        engine
                .platformViewsController.registry
                .registerViewFactory(
                        "PlatformVideoPlayer.VIDEO_PLAYER", NativeVideoPlayerFactory(engine.dartExecutor.binaryMessenger))
    }
}