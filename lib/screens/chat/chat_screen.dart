import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skillbarter/models/services/auth_services.dart';
import 'package:skillbarter/models/services/common_helper.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
          'Messages',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: AuthService.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
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

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(
              child: Text(
                'No conversations yet',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chats.length,
            itemBuilder: (_, i) {
              final chat = chats[i].data() as Map<String, dynamic>;
              final chatId = chats[i].id;

              final participants = List<String>.from(chat['participants']);
              final otherUserId = participants.firstWhere(
                (id) => id != AuthService.uid,
              );

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData) {
                    return const SizedBox();
                  }

                  final user = userSnap.data!.data() as Map<String, dynamic>;

                  final convo = {
                    'name': user['name'] ?? 'Unknown',
                    'initials': CommonHelper.getInitials(user['name'] ?? 'U'),
                    'lastMessage': chat['last_message'] ?? '',
                    'time': 'Now',
                    'unread': 0,
                    'status': 'Active',
                    'title': chat['post_title'] ?? '',
                    'requestId': chat['request_id'],
                  };

                  return _buildConversationCard(convo, chatId);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildConversationCard(Map<String, dynamic> convo, String chatId) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
            chatId: chatId,
            requestId: convo['requestId'],
            name: convo['name'],
            initials: convo['initials'],
            status: convo['status'],
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2D5A3D),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF4CAF72),
                  child: Text(
                    convo['initials'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3A2D),
                    ),
                  ),
                ),
                if (convo['unread'] > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF72),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${convo['unread']}',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${convo["title"]} - ${convo["name"]}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        convo['time'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6AAD7A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    convo['lastMessage'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFA3C4A8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: convo['status'].contains('✅')
                          ? const Color(0xFF1B3A2D)
                          : const Color(0xFF1B3A2D),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      convo['status'],
                      style: TextStyle(
                        fontSize: 10,
                        color: convo['status'].contains('✅')
                            ? const Color(0xFF4CAF72)
                            : const Color(0xFF6AAD7A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String requestId;
  final String name;
  final String initials;
  final String status;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.requestId,
    required this.name,
    required this.initials,
    required this.status,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();

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
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF4CAF72),
              child: Text(
                widget.initials,
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
                  widget.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.status,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4CAF72),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('post_requests')
                .doc(widget.requestId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final request = snapshot.data!.data() as Map<String, dynamic>;

              final requesterStatus = request['requester_status'];

              final ownerStatus = request['post_owner_status'];

              final barterAgreed =
                  requesterStatus == 'accepted' && ownerStatus == 'accepted';

              if (barterAgreed) {
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D5A3D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Color(0xFF4CAF72),
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Barter Agreed! 🎉',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4CAF72),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final isRequester = request['requester_id'] == AuthService.uid;

              final requesterAccepted = (requesterStatus == 'accepted');
              final ownerAccepted = (ownerStatus == 'accepted');

              String titleRequestMessage = "Send barter request?";
              String buttonText = 'Send';
              bool canPress = true;

              if (isRequester && requesterAccepted && !ownerAccepted) {
                titleRequestMessage = "Waiting for approval";
                buttonText = 'Request Sent';
                canPress = false;
              }

              if (!isRequester && !ownerAccepted) {
                titleRequestMessage = "Accept barter request?";
                buttonText = 'Accept';
              }

              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D5A3D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      titleRequestMessage,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF72),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: canPress
                          ? () async {
                              await FirebaseFirestore.instance
                                  .collection('post_requests')
                                  .doc(widget.requestId)
                                  .update({
                                    isRequester
                                            ? 'requester_status'
                                            : 'post_owner_status':
                                        'accepted',
                                  });
                            }
                          : null,
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B3A2D),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('chat_id', isEqualTo: widget.chatId)
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4CAF72)),
                  );
                }

                final messages = snapshot.data!.docs;

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i].data() as Map<String, dynamic>;

                    return _buildMessage({
                      'text': msg['text'],
                      'isMe': msg['sender_id'] == AuthService.uid,
                    });
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF2D5A3D),
              border: Border(top: BorderSide(color: Color(0xFF1B3A2D))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Color(0xFF6AAD7A)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (_messageController.text.isNotEmpty) {
                      final text = _messageController.text.trim();

                      if (text == "") {
                        return;
                      }

                      _messageController.clear();

                      await FirebaseFirestore.instance
                          .collection('messages')
                          .add({
                            'chat_id': widget.chatId,
                            'sender_id': AuthService.uid,
                            'text': text,
                            'createdAt': FieldValue.serverTimestamp(),
                          });

                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(widget.chatId)
                          .update({'last_message': text});
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF72),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Color(0xFF1B3A2D),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    return Align(
      alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: msg['isMe']
              ? const Color(0xFF4CAF72)
              : const Color(0xFF2D5A3D),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          msg['text'],
          style: TextStyle(
            fontSize: 13,
            color: msg['isMe'] ? const Color(0xFF1B3A2D) : Colors.white,
          ),
        ),
      ),
    );
  }
}
