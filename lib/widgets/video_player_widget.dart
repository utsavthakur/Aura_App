import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:aura_app/theme/app_colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    
    await _videoPlayerController.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.sunsetCoral,
        handleColor: AppColors.sunsetCoral,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white.withOpacity(0.5),
      ),
      placeholder: Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator(color: AppColors.sunsetCoral)),
      ),
      autoInitialize: true,
    );
    
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
        ? Chewie(controller: _chewieController!)
        : const Center(child: CircularProgressIndicator(color: AppColors.sunsetCoral));
  }
}
