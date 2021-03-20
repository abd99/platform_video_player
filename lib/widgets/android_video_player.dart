import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';

typedef NativeWidgetCreatedCallback = void Function(
    NativeWidgetController controller);

class AndroidVideoPlayer extends StatefulWidget {
  AndroidVideoPlayer({
    @required this.onNativeWidgetCreated,
    @required Key key,
  }) : super(key: key);

  final NativeWidgetCreatedCallback onNativeWidgetCreated;

  @override
  _AndroidVideoPlayerState createState() => _AndroidVideoPlayerState();
}

class _AndroidVideoPlayerState extends State<AndroidVideoPlayer>
    with WidgetsBindingObserver {
  int id;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        widget.onNativeWidgetCreated(NativeWidgetController._(id)..pause());
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key,
      onVisibilityChanged: (info) {
        debugPrint("${info.visibleFraction} of my widget is visible");
        if (info.visibleFraction <= 0) {
          widget.onNativeWidgetCreated(NativeWidgetController._(id)..pause());
        }
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: AndroidView(
          viewType: 'PlatformVideoPlayer.VIDEO_PLAYER',
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onPlatformViewCreated(int id) {
    this.id = id;
    debugPrint('PINGGGG: ID from AndroidView: $id');
    if (widget.onNativeWidgetCreated == null) {
      return;
    }
    widget.onNativeWidgetCreated(NativeWidgetController._(id)..ping());
  }
}

class NativeWidgetController {
  NativeWidgetController._(int id)
      : _channel = MethodChannel('PlatformVideoPlayer.VIDEO_PLAYER_$id');

  final MethodChannel _channel;

  Future<void> ping() async {
    return _channel.invokeMethod('ping');
  }

  Future<void> initialize() async {
    return _channel.invokeMethod('initialize');
  }

  Future<void> pause() async {
    return _channel.invokeMethod('pause');
  }
}
