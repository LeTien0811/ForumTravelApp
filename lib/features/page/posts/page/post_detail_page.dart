import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_torum_app/data/model/post/post_comment_model.dart';
import 'package:travel_torum_app/data/model/post/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailPage extends StatefulWidget {
  final PostModel post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  final TextEditingController _commentController = TextEditingController();
  
  late List<PostCommentModel> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.post.comment); // Tạo bản sao

    // Logic khởi tạo video (giống hệt PostCard)
    if (widget.post.media.isNotEmpty && widget.post.media.first.type == 'video') {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.post.media.first.url),
      )..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController?.setLooping(true);
        });
    }
    timeago.setLocaleMessages('vi', timeago.ViMessages());
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              widget.post.author.avata_url,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.post.author.firts_name} ${widget.post.author.last_name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                timeago.format(widget.post.create_at, locale: 'vi'),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () { /* TODO: Mở menu options */ },
          ),
        ],
      ),
    );
  }

  // (Không thay đổi)
  Widget _buildMedia() {
    if (widget.post.media.isEmpty) {
      return const SizedBox.shrink();
    }
    if (widget.post.media.length == 1) {
      final media = widget.post.media.first;
      if (media.type == 'video') {
        return _buildVideoPlayer();
      }
      return _buildSingleImage(media.url);
    }
    return _buildImageGrid();
  }

  // (Không thay đổi)
  Widget _buildVideoPlayer() {
    if (_isVideoInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_videoController!),
            GestureDetector(
              onTap: () {
                setState(() {
                  _videoController!.value.isPlaying
                      ? _videoController!.pause()
                      : _videoController!.play();
                });
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black.withOpacity(0.5),
                child: Icon(
                  _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      height: 300,
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildSingleImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (context, url) => Container(
        height: 300,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        height: 300,
        color: Colors.grey[200],
        child: const Icon(Icons.error, color: Colors.red),
      ),
    );
  }

  // (Không thay đổi)
  Widget _buildImageGrid() {
    return GridView.builder(
      itemCount: widget.post.media.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.post.media.length > 2 ? 3 : 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        final media = widget.post.media[index];
        return CachedNetworkImage(
          imageUrl: media.url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget _buildStats() {
     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red[400], size: 18),
              const SizedBox(width: 4),
              Text(
                "${widget.post.like.length}",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Icon(Icons.chat_bubble_outline, color: Colors.grey[600], size: 18),
              const SizedBox(width: 4),
              Text(
                "${_comments.length} Comments", // <-- Sửa để dùng state cục bộ
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.favorite_border,
          label: "Thích",
          onPressed: () { /* TODO: Xử lý Like */ },
        ),

        _buildActionButton(
          icon: Icons.error_outline,
          label: "Báo Cáo",
          onPressed: () { context.go('/ReportPostPage', extra: widget.post); },
        ),
        
        _buildActionButton(
          icon: Icons.share_outlined,
          label: "Chia sẻ",
          onPressed: () { /* TODO: Xử lý Share */ },
        ),
      ],
    );
  }
  
  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.grey[600], size: 20),
        label: Text(
          label,
          style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.normal),
        ),
        style: TextButton.styleFrom(
          foregroundColor: Colors.black26,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.title.isNotEmpty)
            Text(
              widget.post.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          const SizedBox(height: 8),
          
          Text(
            widget.post.content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }


  Widget _buildCommentList() {
    if (_comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text("Chưa có bình luận nào. Hãy là người đầu tiên!"),
        ),
      );
    }
    
    return ListView.builder(
      itemCount: _comments.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final comment = _comments[index];
      
        final author = widget.post.author; 

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(author.avata_url),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${author.firts_name} ${author.last_name}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(comment.content, style: const TextStyle(height: 1.4)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitComment() {
    final content = _commentController.text.trim();
    if (content.isEmpty) {
      return; // Không gửi comment rỗng
    }

    final newComment = PostCommentModel(
      id: "temp-${DateTime.now().millisecondsSinceEpoch}",
      content: content,
      create_at: DateTime.now(),
    );

    setState(() {
      _comments.add(newComment); 
      _commentController.clear();
      FocusScope.of(context).unfocus(); 
    });
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 8.0, 
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: CachedNetworkImageProvider(widget.post.author.avata_url), 
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Viết bình luận...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: (value) => _submitComment(),
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: _submitComment,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Bài viết"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildContent(), 
                  _buildMedia(),
                  _buildStats(),
                  const Divider(height: 1),
                  _buildActions(),
                  
                  Divider(thickness: 8, color: Colors.grey[200]),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Bình luận",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  _buildCommentList(),
                ],
              ),
            ),
          ),
          
          _buildCommentInput(),
        ],
      ),
    );
  }
}