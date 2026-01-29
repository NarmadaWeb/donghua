import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../constants/colors.dart';
import '../../models/donghua.dart';
import '../../providers/auth_provider.dart';
import '../../providers/content_provider.dart';
import '../../widgets/glass_container.dart';
import 'player_screen.dart';
import 'auth/login_screen.dart';

class DetailScreen extends StatefulWidget {
  final Donghua donghua;
  const DetailScreen({super.key, required this.donghua});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  void _postComment() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }

    if (_commentController.text.trim().isEmpty) return;

    final content = _commentController.text.trim();
    _commentController.clear();

    // Unfocus keyboard
    FocusScope.of(context).unfocus();

    await Provider.of<ContentProvider>(context, listen: false).addComment(
      auth.currentUser!.id,
      auth.currentUser!.username,
      widget.donghua.id,
      content,
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final comments = contentProvider.getCommentsForDonghua(widget.donghua.id);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image & Play Button
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.donghua.coverUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black26, Colors.transparent, AppColors.backgroundDark],
                            stops: [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: widget.donghua.videoUrl.isNotEmpty
                              ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(videoUrl: widget.donghua.videoUrl)))
                              : null,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: widget.donghua.videoUrl.isNotEmpty
                                  ? AppColors.primary.withOpacity(0.9)
                                  : Colors.grey.withOpacity(0.5),
                              shape: BoxShape.circle,
                              boxShadow: widget.donghua.videoUrl.isNotEmpty
                                  ? [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)]
                                  : [],
                            ),
                            child: Icon(
                                Icons.play_arrow,
                                color: widget.donghua.videoUrl.isNotEmpty ? Colors.white : Colors.white54,
                                size: 40
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.donghua.title,
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.primary, size: 16),
                          const SizedBox(width: 4),
                          Text('${widget.donghua.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 16),
                          Text('${widget.donghua.episodes} Episodes', style: const TextStyle(color: AppColors.textLight)),
                          const SizedBox(width: 16),
                          Text(widget.donghua.status, style: const TextStyle(color: AppColors.textLight)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.donghua.genres.map((g) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Text(g, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                        )).toList(),
                      ),
                      const SizedBox(height: 16),
                      if (widget.donghua.videoUrl.isNotEmpty) ...[
                        const Text('Video Link:', style: TextStyle(color: AppColors.textLight, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        SelectableText(
                          widget.donghua.videoUrl,
                          style: const TextStyle(color: AppColors.accentPurple, fontSize: 12, decoration: TextDecoration.underline),
                        ),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 16),
                      const Text('Synopsis', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        widget.donghua.description,
                        style: const TextStyle(color: AppColors.textLight, height: 1.5),
                      ),

                      const SizedBox(height: 32),

                      // Episodes Grid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Episodes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text('Season 1', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: 10, // Mock number of episodes displayed
                        itemBuilder: (context, index) {
                          final epNum = index + 1;
                          final isFirst = index == 0;
                          return Container(
                            decoration: BoxDecoration(
                              color: isFirst ? AppColors.primary : AppColors.cardDark,
                              borderRadius: BorderRadius.circular(8),
                              border: isFirst ? null : Border.all(color: Colors.white10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$epNum',
                              style: TextStyle(
                                color: isFirst ? Colors.white : AppColors.textLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Comments
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Comments (${comments.length})', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text('Newest', style: TextStyle(color: AppColors.textLight)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (comments.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: Text("No comments yet. Be the first!", style: TextStyle(color: Colors.white38))),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final comment = comments[comments.length - 1 - index]; // Reverse order
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.cardDark,
                                  child: Text(comment.username[0].toUpperCase()),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(comment.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                          Text(
                                            timeago.format(DateTime.tryParse(comment.timestamp) ?? DateTime.now()),
                                            style: const TextStyle(color: Colors.white30, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.cardDark,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                                        ),
                                        child: Text(comment.content, style: const TextStyle(color: AppColors.textLight)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Custom AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassContainer(
              borderRadius: BorderRadius.zero,
              color: AppColors.backgroundDark.withOpacity(0.5),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.share, color: Colors.white, size: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Bar (Input)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GlassContainer(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              color: AppColors.backgroundDark.withOpacity(0.95),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     // Add to Watchlist Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text("Add to Watchlist"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Comment Input
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.cardDark,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _commentController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Write a comment...',
                                      hintStyle: TextStyle(color: Colors.white30),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _postComment,
                                  child: const Icon(Icons.send, color: AppColors.primary, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
