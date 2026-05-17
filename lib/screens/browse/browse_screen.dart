import 'package:flutter/material.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'All', 'Design', 'Coding', 'Music', 'Photo', 'Writing', 'Marketing'
  ];

  final List<Map<String, dynamic>> _allPosts = [
    {
      'name': 'Anna Lee', 'initials': 'AL',
      'role': 'UI/UX Designer', 'title': 'Figma UI Design',
      'description': 'I offer Figma design sessions in exchange for coding help',
      'category': 'Design', 'wants': 'Coding skills',
    },
    {
      'name': 'Marco Reyes', 'initials': 'MR',
      'role': 'Guitar Teacher', 'title': 'Guitar Lessons',
      'description': 'Teaching basic to advanced guitar in exchange for video editing',
      'category': 'Music', 'wants': 'Video editing',
    },
    {
      'name': 'Sofia Cruz', 'initials': 'SC',
      'role': 'Photographer', 'title': 'Portrait Photography',
      'description': 'Offering portrait shoots in exchange for social media management',
      'category': 'Photo', 'wants': 'Social media',
    },
    {
      'name': 'Juan dela Cruz', 'initials': 'JD',
      'role': 'Flutter Developer', 'title': 'Mobile App Development',
      'description': 'Building Flutter apps in exchange for graphic design work',
      'category': 'Coding', 'wants': 'Graphic design',
    },
    {
      'name': 'Maria Santos', 'initials': 'MS',
      'role': 'Content Writer', 'title': 'Blog Writing',
      'description': 'Writing SEO blogs in exchange for web development help',
      'category': 'Writing', 'wants': 'Web development',
    },
    {
      'name': 'Paolo Reyes', 'initials': 'PR',
      'role': 'Digital Marketer', 'title': 'Social Media Marketing',
      'description': 'Managing social media accounts in exchange for graphic design',
      'category': 'Marketing', 'wants': 'Graphic design',
    },
  ];

  List<Map<String, dynamic>> get _filteredPosts {
    return _allPosts.where((post) {
      final matchCategory = _selectedCategory == 'All' ||
          post['category'] == _selectedCategory;
      final matchSearch = _searchController.text.isEmpty ||
          post['title'].toLowerCase()
            .contains(_searchController.text.toLowerCase()) ||
          post['name'].toLowerCase()
            .contains(_searchController.text.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
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
        title: const Text('Browse Skills',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D5A3D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search skills or people...',
                  hintStyle: TextStyle(color: Color(0xFF6AAD7A)),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF6AAD7A)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final isSelected = _selectedCategory == _categories[i];
                return GestureDetector(
                  onTap: () => setState(() =>
                    _selectedCategory = _categories[i]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                        ? const Color(0xFF4CAF72)
                        : const Color(0xFF2D5A3D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_categories[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                          ? const Color(0xFF1B3A2D)
                          : const Color(0xFFA3C4A8),
                      )),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                Text('${_filteredPosts.length} skills found',
                  style: const TextStyle(
                    fontSize: 12, color: Color(0xFF6AAD7A))),
              ],
            ),
          ),
          Expanded(
            child: _filteredPosts.isEmpty
              ? const Center(
                  child: Text('No skills found',
                    style: TextStyle(color: Color(0xFFA3C4A8))))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filteredPosts.length,
                  itemBuilder: (_, i) => _buildSkillCard(_filteredPosts[i]),
                ),
          ),
        ],
      ),
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
              style: const TextStyle(fontSize: 11,
                color: Color(0xFF6AAD7A))),
          ]),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF1B3A2D),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(post['category'],
              style: const TextStyle(fontSize: 10,
                color: Color(0xFF4CAF72))),
          ),
        ]),
        const SizedBox(height: 10),
        Text(post['title'],
          style: const TextStyle(fontSize: 14,
            fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(post['description'],
          style: const TextStyle(fontSize: 12,
            color: Color(0xFFA3C4A8))),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Wants: ${post['wants']}',
            style: const TextStyle(fontSize: 11,
              color: Color(0xFF6AAD7A))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF72),
              padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 6),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {},
            child: const Text('Request',
              style: TextStyle(fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3A2D))),
          ),
        ]),
      ]),
    );
  }
}
