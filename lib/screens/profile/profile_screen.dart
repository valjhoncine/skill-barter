import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillbarter/models/services/auth_services.dart';
import 'package:skillbarter/models/services/post_service.dart';
import 'package:skillbarter/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PostService _postService = PostService();
  final AuthService _authService = AuthService();

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3A2D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3A2D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF6AAD7A)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _authService.getUserStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4CAF72)),
                  );
                }

                final userData = snapshot.data!.data();

                final name = userData?['name'] ?? 'No Name';
                final title = userData?['title'] ?? '';
                final location = userData?['location'] ?? '';
                final description = userData?['description'] ?? '';

                return _buildProfileHeader(
                  name: name,
                  title: title,
                  location: location,
                  description: description,
                );
              },
            ),
            _buildStatsRow(),
            _buildSkillTags(),
            _buildMyPosts(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader({
    required String name,
    required String title,
    required String location,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: const Color(0xFF4CAF72),
                child: const Text(
                  'Me',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3A2D),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF72),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                    color: Color(0xFF1B3A2D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 13, color: Color(0xFF6AAD7A))),
          const SizedBox(height: 8),
          Text(
            '$location 📍',
            style: TextStyle(fontSize: 12, color: Color(0xFFA3C4A8)),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D5A3D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFFA3C4A8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _postService.getPosts(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];

              final postCount = docs
                  .where((doc) => doc['owner_id'] == AuthService.uid)
                  .length;

              return _buildStat(postCount.toString(), 'Posts');
            },
          ),
          _buildDivider(),
          StreamBuilder<QuerySnapshot>(
            stream: _postService.getAcceptedExchanges(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildStat('0', 'Exchanges');
              }

              final docs = snapshot.data!.docs;
              
              final exchangeCount = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;

                return data['post_owner_id'] == AuthService.uid ||
                    data['requester_id'] == AuthService.uid;
              }).length;

              return _buildStat(exchangeCount.toString(), 'Exchanges');
            },
          ),
          _buildDivider(),
          _buildStat('⭐ 4.8', 'Rating'),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6AAD7A)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: const Color(0xFF1B3A2D));
  }

  Widget _buildSkillTags() {
    final skills = ['Flutter', 'Dart', 'Figma', 'UI Design', 'Firebase'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Skills',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D5A3D),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF4CAF72)),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4CAF72),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPosts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Posts',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: _postService.getPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  'Failed to load posts',
                  style: TextStyle(color: Colors.white),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4CAF72)),
                );
              }

              final docs = snapshot.data!.docs.where((doc) {
                return doc['owner_id'] == AuthService.uid;
              }).toList();

              if (docs.isEmpty) {
                return const Text(
                  'No posts yet',
                  style: TextStyle(color: Color(0xFFA3C4A8)),
                );
              }

              return Column(
                children: docs.map((doc) {
                  final post = doc.data() as Map<String, dynamic>;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D5A3D),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['title'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Wants: ${post['wants']}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6AAD7A),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
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
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF4CAF72)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 14, color: Color(0xFF4CAF72)),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
