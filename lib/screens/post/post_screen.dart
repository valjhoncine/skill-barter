import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skillbarter/models/services/auth_services.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _wantsController = TextEditingController();
  String _selectedCategory = 'Design';
  bool isLoading = false;

  void setLoading(bool s) {
    setState(() {
      isLoading = s;
    });
  }

  void clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    _wantsController.clear();
    _selectedCategory = "Design";
  }

  final List<String> _categories = [
    'Design',
    'Coding',
    'Music',
    'Photo',
    'Writing',
    'Marketing',
    'Other',
  ];

  Future<void> createPost() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final wants = _wantsController.text.trim();
    final category = _selectedCategory;

    if (title == "" || description == "" || wants == "" || category == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please make sure to fill all fields.')),
      );
      return;
    }
    setLoading(true);
    try {
      final user = AuthService.user;

      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
        return;
      }

      await FirebaseFirestore.instance.collection('posts').add({
        'owner_id': user.uid,
        'title': title,
        'description': description,
        'category': category,
        'wants': wants,
        'status': 'open',
        'createdAt': Timestamp.now(),
      });

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully')),
      );
      clearFields();
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Create Post Failed')),
      );
    } finally {
      setLoading(false);
    }
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
          'Post a Skill',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skill Title',
              style: TextStyle(
                color: Color(0xFF6AAD7A),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildInputField('e.g. Figma UI Design', _titleController, false),
            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(
                color: Color(0xFF6AAD7A),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildInputField(
              'Describe what you offer...',
              _descriptionController,
              true,
            ),
            const SizedBox(height: 20),

            const Text(
              'Category',
              style: TextStyle(
                color: Color(0xFF6AAD7A),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4CAF72)
                          : const Color(0xFF2D5A3D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF1B3A2D)
                            : const Color(0xFFA3C4A8),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            const Text(
              'What do you want in return?',
              style: TextStyle(
                color: Color(0xFF6AAD7A),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildInputField(
              'e.g. Coding help, Video editing...',
              _wantsController,
              false,
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF72),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  await createPost();
                },
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Post Skill',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B3A2D),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String hint,
    TextEditingController controller,
    bool isMultiline,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A3D),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: isMultiline ? 4 : 1,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFA3C4A8)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
