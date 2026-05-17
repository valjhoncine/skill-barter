import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillbarter/models/services/auth_services.dart';

class PostService {
  final CollectionReference posts = FirebaseFirestore.instance.collection(
    'posts',
  );
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> createPost({
    required String title,
    required String description,
    required String wants,
    required String category,
  }) async {
    final user = AuthService.user;

    if (user == null) {
      throw Exception('User not logged in');
    }
    final userDoc = await users.doc(user.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;

    await posts.add({
      'owner_id': user.uid,
      'name': userData["name"],
      'roles': userData["title"],
      'title': title,
      'description': description,
      'category': category,
      'wants': wants,
      'status': 'open',
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return posts.orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAcceptedExchanges() {
    return FirebaseFirestore.instance
        .collection('post_requests')
        .where('post_owner_status', isEqualTo: 'accepted')
        .where('requester_status', isEqualTo: 'accepted')
        .snapshots();
  }
}
