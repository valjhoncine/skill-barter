import 'package:flutter/material.dart';
import '../post/post_screen.dart';
import '../browse/browse_screen.dart';
import '../profile/profile_screen.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _skillPosts = [
    {
      'name': 'Anna Lee',
      'initials': 'AL',
      'role': 'UI/UX Designer',
      'title': 'Figma UI Design',
      'description': 'I offer Figma design sessions in exchange for coding help',
      'category': 'Design',
      'wants': 'Coding skills',
    },
    {
      'name': 'Marco Reyes',
      'initials': 'MR',
      'role': 'Guitar Teacher',
      'title': 'Guitar Lessons',
      'description': 'Teaching basic to advanced guitar in exchange for video editing',
      'category': 'Music',
      'wants': 'Video editing',
    },
    {
      'name': 'Sofia Cruz',
      'initials': 'SC',
      'role': 'Photographer',
      'title': 'Portrait Photography',
      'description': 'Offering portrait shoots in exchange for social media management',
      'category': 'Photo',
      'wants': 'Social media',
    },
    {
      'name': 'Juan dela Cruz',
      'initials': 'JD',
      'role': 'Flutter Developer',
      'title': 'Mobile App Development',
      'description': 'Building Flutter apps in exchange for graphic design work',
      'category': 'Coding',
      'wants': 'Graphic design',
    },
  ];

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
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Good day 👋',
              style: TextStyle(fontSize: 13, color: Color(0xFF6AAD7A))),
            const Text('Find a Skill',
              style: TextStyle(fontSize: 22,
                fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          CircleAvatar(
            backgroundColor: const Color(0xFF4CAF72),
            child: const Text('Me',
              style: TextStyle(fontSize: 12,
                fontWeight: FontWeight.bold, color: Color(0xFF1B3A2D))),
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
        child: Row(children: [
          const Icon(Icons.search, color: Color(0xFF6AAD7A), size: 20),
          const SizedBox(width: 10),
          const Text('Search skills...',
            style: TextStyle(color: Color(0xFF6AAD7A), fontSize: 14)),
        ]),
      ),
    );
  }

  Widget _buildCategoryPills() {
    final categories = ['All', 'Design', 'Coding', 'Music', 'Photo'];
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
          child: Text(categories[i],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: i == 0 ? const Color(0xFF1B3A2D) : const Color(0xFFA3C4A8),
            )),
        ),
      ),
    );
  }

  Widget _buildSkillList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _skillPosts.length,
      itemBuilder: (_, i) => _buildSkillCard(_skillPosts[i]),
    );
  }

  Widget _buildSkillCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF4CAF72),
            child: Text(post['initials'],
              style: const TextStyle(fontSize: 11,
                fontWeight: FontWeight.bold, color: Color(0xFF1B3A2D))),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(post['name'],
              style: const TextStyle(fontSize: 13,
                fontWeight: FontWeight.w600, color: Colors.white)),
            Text(post['role'],
              style: const TextStyle(fontSize: 11, color: Color(0xFF6AAD7A))),
          ]),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF1B3A2D),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(post['category'],
              style: const TextStyle(fontSize: 10, color: Color(0xFF4CAF72))),
          ),
        ]),
        const SizedBox(height: 10),
        Text(post['title'],
          style: const TextStyle(fontSize: 14,
            fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(post['description'],
          style: const TextStyle(fontSize: 12, color: Color(0xFFA3C4A8))),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Wants: ${post['wants']}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF6AAD7A))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF72),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ChatScreen())),
            child: const Text('Request',
              style: TextStyle(fontSize: 11,
                fontWeight: FontWeight.bold, color: Color(0xFF1B3A2D))),
          ),
        ]),
      ]),
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
        if (i == 1) {
          await Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BrowseScreen()));
        } else if (i == 2) {
          await Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PostScreen()));
        } else if (i == 3) {
          await Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ChatScreen()));
        } else if (i == 4) {
          await Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()));
        }
        setState(() => _currentIndex = 0);
      },
      backgroundColor: const Color(0xFF1B3A2D),
      selectedItemColor: const Color(0xFF4CAF72),
      unselectedItemColor: const Color(0xFF6AAD7A),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded), label: 'Browse'),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_rounded), label: 'Post'),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_rounded), label: 'Messages'),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    ),
  );
}
}
