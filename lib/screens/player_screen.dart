import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../constants/colors.dart';

class PlayerScreen extends StatefulWidget {
  final String videoUrl;
  const PlayerScreen({super.key, required this.videoUrl});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    if (widget.videoUrl.isEmpty) {
      return;
    }

    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl));

    _videoPlayerController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: true,
          aspectRatio: 16/9,
          fullScreenByDefault: false,

          // Customizing UI to match prototype partially (Chewie does a lot, but we can theme it)
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.primary,
            handleColor: Colors.white,
            backgroundColor: Colors.white24,
            bufferedColor: Colors.white10,
          ),
          placeholder: Container(
            color: Colors.black,
          ),
          autoInitialize: true,
        );
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: widget.videoUrl.isEmpty
              ? const Text('No Video URL', style: TextStyle(color: Colors.white))
              : (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : const CircularProgressIndicator(color: AppColors.primary)),
          ),

          // Custom Header (Overlay) - Only visible if we implemented custom controls,
          // but with Chewie it handles it. We can add a back button on top if we want.
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
