import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skillbarter/models/services/auth_services.dart';
import 'package:skillbarter/models/services/common_helper.dart';
import 'package:skillbarter/models/services/post_service.dart';
import '../post/post_screen.dart';
// import '../browse/browse_screen.dart';
import '../profile/profile_screen.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _postService = PostService();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3A2D),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildSearchBar(),
            _buildCategoryPills(),
            Expanded(child: _buildSkillList()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good day 👋',
                style: TextStyle(fontSize: 13, color: Color(0xFF6AAD7A)),
              ),
              const Text(
                'Find a Skill',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: const Color(0xFF4CAF72),
            child: const Text(
              'Me',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3A2D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2D5A3D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFF6AAD7A), size: 20),
            const SizedBox(width: 10),
            const Text(
              'Search skills...',
              style: TextStyle(color: Color(0xFF6AAD7A), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPills() {
    final categories = [];
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (_, i) => Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: i == 0 ? const Color(0xFF4CAF72) : const Color(0xFF2D5A3D),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            categories[i],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: i == 0 ? const Color(0xFF1B3A2D) : const Color(0xFFA3C4A8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _postService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4CAF72)),
          );
        }

        final posts = snapshot.data!.docs.where((doc) {
          return doc['owner_id'] != AuthService.uid && doc['status'] == 'open';
        }).toList();

        if (posts.isEmpty) {
          return const Center(
            child: Text('No posts yet', style: TextStyle(color: Colors.white)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: posts.length,
          itemBuilder: (_, i) {
            final post = posts[i].data() as Map<String, dynamic>;
            final doc = posts[i];
            final docId = doc.id;

            return _buildSkillCard(post, docId);
          },
        );
      },
    );
  }

  Widget _buildSkillCard(Map<String, dynamic> post, String postId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF4CAF72),
                child: Text(
                  CommonHelper.getInitials(post['name']),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3A2D),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['name'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    post['role'] ?? "",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6AAD7A),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3A2D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  post['category'],
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4CAF72),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post['title'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            post['description'],
            style: const TextStyle(fontSize: 12, color: Color(0xFFA3C4A8)),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wants: ${post['wants']}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF6AAD7A)),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('post_requests')
                    .where('post_id', isEqualTo: postId)
                    .where('requester_id', isEqualTo: AuthService.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  final alreadyRequested = snapshot.data!.docs.isNotEmpty;

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF72),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (!alreadyRequested) {
                        final ownerId = post['owner_id'];
                        final requesterId = AuthService.uid;

                        final requestRef = await FirebaseFirestore.instance
                            .collection('post_requests')
                            .add({
                              'post_id': postId,
                              'post_title': post['title'],
                              'post_name': post['name'],
                              'post_owner_id': ownerId,
                              'post_owner_status': 'pending',
                              'requester_id': requesterId,
                              'requester_status': 'pending',
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                        await FirebaseFirestore.instance
                            .collection('chats')
                            .add({
                              'post_id': postId,
                              'request_id': requestRef.id,
                              'post_title': post['title'],
                              'participants': [ownerId, requesterId],
                              'last_message': '',
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                        if (!context.mounted) {
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChatScreen()),
                        );
                      }
                    },
                    child: Text(
                      (alreadyRequested) ? 'Requested' : 'Request',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B3A2D),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1B3A2D),
        border: Border(top: BorderSide(color: Color(0xFF2D5A3D))),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) async {
          // if (i == 1) {
          //   // await Navigator.push(
          //   //   context,
          //   //   MaterialPageRoute(builder: (_) => const BrowseScreen()),
          //   // );
          // } else
          if (i == 1) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PostScreen()),
            );
          } else if (i == 2) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatScreen()),
            );
          } else if (i == 3) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
          setState(() => _currentIndex = 0);
        },
        backgroundColor: const Color(0xFF1B3A2D),
        selectedItemColor: const Color(0xFF4CAF72),
        unselectedItemColor: const Color(0xFF6AAD7A),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search_rounded),
          //   label: 'Browse',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
