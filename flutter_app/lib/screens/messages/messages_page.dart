import 'package:flutter/material.dart';
import 'package:aura_app/widgets/glass_container.dart';
import 'package:aura_app/theme/app_colors.dart';
import 'package:aura_app/core/performance/optimized_image_manager.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chats = [
      {
        'name': 'Alex Rivers',
        'message': 'That last post was ethereal! 🌌',
        'time': '2m ago',
        'unread': 2,
        'image': 'https://picsum.photos/id/22/200/200.jpg',
        'online': true,
      },
      {
        'name': 'Sarah Chen',
        'message': 'Are we still meeting at the gallery?',
        'time': '15m ago',
        'unread': 0,
        'image': 'https://picsum.photos/id/26/200/200.jpg',
        'online': false,
      },
      {
        'name': 'Jordan Smith',
        'message': 'Sent you the high-res files.',
        'time': '1h ago',
        'unread': 0,
        'image': 'https://picsum.photos/id/32/200/200.jpg',
        'online': true,
      },
      {
        'name': 'Elena Vance',
        'message': 'The lighting in this capture is perfect.',
        'time': '3h ago',
        'unread': 1,
        'image': 'https://picsum.photos/id/45/200/200.jpg',
        'online': false,
      },
      {
        'name': 'Marcus Wright',
        'message': 'Check out this new shader I found.',
        'time': 'Yesterday',
        'unread': 0,
        'image': 'https://picsum.photos/id/52/200/200.jpg',
        'online': false,
      },
      {
        'name': 'Design Team',
        'message': 'New brand assets are ready.',
        'time': 'Yesterday',
        'unread': 5,
        'image': 'https://picsum.photos/id/60/200/200.jpg',
        'online': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GlassContainer(
                      width: 45,
                      height: 45,
                      borderRadius: 15,
                      child: const Icon(Icons.edit_note_rounded, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GlassContainer(
                height: 45,
                borderRadius: 22.5,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: AppColors.textTertiary, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Search messages...',
                      style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Active Now (Horizontal List)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Text(
                    'ACTIVE NOW',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: chats.where((c) => c['online'] == true).length,
                    itemBuilder: (context, index) {
                      final activeChats = chats.where((c) => c['online'] == true).toList();
                      final chat = activeChats[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: ClipOval(
                                      child: OptimizedNetworkImage(
                                        imageUrl: chat['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  bottom: 2,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.midnightInk, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Chat List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final chat = chats[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GlassContainer(
                      borderRadius: 20,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: OptimizedNetworkImage(
                              imageUrl: chat['image'],
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chat['name'],
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      chat['time'],
                                      style: const TextStyle(
                                        color: AppColors.textTertiary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        chat['message'],
                                        style: TextStyle(
                                          color: chat['unread'] > 0 
                                              ? AppColors.textPrimary 
                                              : AppColors.textSecondary,
                                          fontSize: 14,
                                          fontWeight: chat['unread'] > 0 
                                              ? FontWeight.w600 
                                              : FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (chat['unread'] > 0)
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: AppColors.accent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          chat['unread'].toString(),
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: chats.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
