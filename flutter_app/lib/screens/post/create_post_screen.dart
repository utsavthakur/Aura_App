import 'package:flutter/material.dart';
import 'package:aura_app/services/post_service.dart';
import 'package:aura_app/theme/app_colors.dart';
import 'package:aura_app/widgets/glass_container.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handlePost() async {
    if (_contentController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await PostService().createPost(
        content: _contentController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aura shared! ✨')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Reveal effect helper
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.midnightInk,
              AppColors.midnightInk.withValues(alpha: 0.8),
              AppColors.duskGray.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handlePost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('POST', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  'Share your Aura',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GlassContainer(
                    width: double.infinity,
                    borderRadius: 24,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: TextStyle(color: AppColors.textTertiary),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _ToolButton(icon: Icons.image_outlined, onTap: () {}),
                    const SizedBox(width: 16),
                    _ToolButton(icon: Icons.videocam_outlined, onTap: () {}),
                    const SizedBox(width: 16),
                    _ToolButton(icon: Icons.location_on_outlined, onTap: () {}),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ToolButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: 50,
      width: 50,
      borderRadius: 15,
      child: IconButton(
        icon: Icon(icon, color: AppColors.accent, size: 24),
        onPressed: onTap,
      ),
    );
  }
}
