import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'Jin Mai Zhao',
      'initials': 'JM',
      'lastMessage': 'Sure! I can help you with Figma.',
      'time': '2:30 PM',
      'unread': 2,
      'status': 'Barter Agreed ✅',
    },
    {
      'name': 'Linghe Zhang',
      'initials': 'LZ',
      'lastMessage': 'When are you available for lessons?',
      'time': '11:00 AM',
      'unread': 0,
      'status': 'Pending',
    },
    {
      'name': 'Xifan Shen',
      'initials': 'XS',
      'lastMessage': 'I sent you the portfolio link!',
      'time': 'Yesterday',
      'unread': 1,
      'status': 'Barter Agreed ✅',
    },
    {
      'name': 'Lusi Zhao',
      'initials': 'LZ',
      'lastMessage': 'Can we exchange our skills?',
      'time': 'Yesterday',
      'unread': 0,
      'status': 'Pending',
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
        title: const Text('Messages',
          style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _conversations.length,
        itemBuilder: (_, i) => _buildConversationCard(_conversations[i]),
      ),
    );
  }

  Widget _buildConversationCard(Map<String, dynamic> convo) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) =>
          ChatDetailScreen(name: convo['name'],
            initials: convo['initials'],
            status: convo['status']))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2D5A3D),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          Stack(children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF4CAF72),
              child: Text(convo['initials'],
                style: const TextStyle(fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3A2D))),
            ),
            if (convo['unread'] > 0)
              Positioned(
                right: 0, top: 0,
                child: Container(
                  width: 16, height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF72),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${convo['unread']}',
                      style: const TextStyle(fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
          ]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(convo['name'],
                      style: const TextStyle(fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                    Text(convo['time'],
                      style: const TextStyle(fontSize: 11,
                        color: Color(0xFF6AAD7A))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(convo['lastMessage'],
                  style: const TextStyle(fontSize: 12,
                    color: Color(0xFFA3C4A8)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: convo['status'].contains('✅')
                      ? const Color(0xFF1B3A2D)
                      : const Color(0xFF1B3A2D),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(convo['status'],
                    style: TextStyle(
                      fontSize: 10,
                      color: convo['status'].contains('✅')
                        ? const Color(0xFF4CAF72)
                        : const Color(0xFF6AAD7A),
                    )),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String initials;
  final String status;

  const ChatDetailScreen({
    super.key,
    required this.name,
    required this.initials,
    required this.status,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hi! I saw your skill post.', 'isMe': false},
    {'text': 'Hey! Yes, I offer Figma design sessions.', 'isMe': true},
    {'text': 'I can help with coding in exchange!', 'isMe': false},
    {'text': 'That sounds great! Let\'s do it!', 'isMe': true},
    {'text': 'Sure! I can help you with Figma.', 'isMe': false},
  ];

  bool _barterAgreed = false;

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
        title: Row(children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF4CAF72),
            child: Text(widget.initials,
              style: const TextStyle(fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3A2D))),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.name,
              style: const TextStyle(fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
            Text(widget.status,
              style: const TextStyle(fontSize: 10,
                color: Color(0xFF4CAF72))),
          ]),
        ]),
      ),
      body: Column(children: [
        if (!_barterAgreed)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D5A3D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Send a Barter Request?',
                  style: TextStyle(fontSize: 13,
                    color: Colors.white)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF72),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => setState(() => _barterAgreed = true),
                  child: const Text('Send Request',
                    style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3A2D))),
                ),
              ],
            ),
          ),
        if (_barterAgreed)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D5A3D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle,
                  color: Color(0xFF4CAF72), size: 18),
                SizedBox(width: 8),
                Text('Barter Agreed! 🎉',
                  style: TextStyle(fontSize: 13,
                    color: Color(0xFF4CAF72),
                    fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _messages.length,
            itemBuilder: (_, i) => _buildMessage(_messages[i]),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFF2D5A3D),
            border: Border(top: BorderSide(color: Color(0xFF1B3A2D))),
          ),
          child: Row(children: [
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
              onTap: () {
                if (_messageController.text.isNotEmpty) {
                  setState(() {
                    _messages.add({
                      'text': _messageController.text,
                      'isMe': true,
                    });
                    _messageController.clear();
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF72),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send,
                  color: Color(0xFF1B3A2D), size: 18),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    return Align(
      alignment: msg['isMe']
        ? Alignment.centerRight
        : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: msg['isMe']
            ? const Color(0xFF4CAF72)
            : const Color(0xFF2D5A3D),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(msg['text'],
          style: TextStyle(
            fontSize: 13,
            color: msg['isMe']
              ? const Color(0xFF1B3A2D)
              : Colors.white,
          )),
      ),
    );
  }
}
