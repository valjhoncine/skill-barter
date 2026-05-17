import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<Map<String, dynamic>> _myPosts = const [
    {
      'title': 'Flutter App Development',
      'category': 'Coding',
      'wants': 'Graphic Design',
      'requests': 3,
    },
    {
      'title': 'UI/UX Consultation',
      'category': 'Design',
      'wants': 'Photography',
      'requests': 1,
    },
  ];

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
        title: const Text('My Profile',
          style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold)),
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
            _buildProfileHeader(),
            _buildStatsRow(),
            _buildSkillTags(),
            _buildMyPosts(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Stack(children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: const Color(0xFF4CAF72),
            child: const Text('Me',
              style: TextStyle(fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3A2D))),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: Container(
              width: 24, height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF72),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit,
                size: 14, color: Color(0xFF1B3A2D)),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        const Text('Joshua Villafuerte',
          style: TextStyle(fontSize: 22,
            fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        const Text('Full Stack Software Engineer | Backend Developer | C# | .Net Core | DevOps',
          style: TextStyle(fontSize: 13, color: Color(0xFF6AAD7A))),
        const SizedBox(height: 8),
        const Text('Parañaque City, Manila📍',
          style: TextStyle(fontSize: 12, color: Color(0xFFA3C4A8))),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2D5A3D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Passionate about building apps and exchanging skills with the community. '
            'Let\'s grow together! 🌱',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFFA3C4A8)),
          ),
        ),
      ]),
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
          _buildStat('2', 'Posts'),
          _buildDivider(),
          _buildStat('4', 'Exchanges'),
          _buildDivider(),
          _buildStat('⭐ 4.8', 'Rating'),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(children: [
      Text(value,
        style: const TextStyle(fontSize: 18,
          fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 2),
      Text(label,
        style: const TextStyle(fontSize: 11,
          color: Color(0xFF6AAD7A))),
    ]);
  }

  Widget _buildDivider() {
    return Container(
      height: 30, width: 1,
      color: const Color(0xFF1B3A2D),
    );
  }

  Widget _buildSkillTags() {
    final skills = ['Flutter', 'Dart', 'Figma', 'UI Design', 'Firebase'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Skills',
            style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: skills.map((skill) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2D5A3D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF4CAF72)),
              ),
              child: Text(skill,
                style: const TextStyle(fontSize: 12,
                  color: Color(0xFF4CAF72))),
            )).toList(),
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
          const Text('My Posts',
            style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          ..._myPosts.map((post) => Container(
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
                    Text(post['title'],
                      style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Wants: ${post['wants']}',
                      style: const TextStyle(fontSize: 11,
                        color: Color(0xFF6AAD7A))),
                    const SizedBox(height: 4),
                    Text('${post['requests']} requests',
                      style: const TextStyle(fontSize: 11,
                        color: Color(0xFFA3C4A8))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B3A2D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(post['category'],
                    style: const TextStyle(fontSize: 10,
                      color: Color(0xFF4CAF72))),
                ),
              ],
            ),
          )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF4CAF72)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text('Logout',
                style: TextStyle(fontSize: 14,
                  color: Color(0xFF4CAF72))),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
