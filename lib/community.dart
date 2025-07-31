import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'ask.dart';
import 'reply.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notification_page.dart';
import 'bottom_navigation_bar.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  int _currentIndex = 1;
  String? _userName;
  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data();
          setState(() {
            _userName = data?['name'];
            _userImageUrl = data?['imageUrl'];
          });
        }
      } catch (e) {
        print('Error loading user profile: $e');
      }
    }
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Morning wellness';
    if (hour < 17) return 'Afternoon balance';
    return 'Evening harmony';
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC), // Warm Sand Beige - same as home page
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section - matching home page style
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo and App Name
                    Row(
                      children: [
                        Text(
                          'Dr. ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2F2F2F), // Charcoal Grey
                          ),
                        ),
                        Text(
                          'ViKi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF27C2A4), // Futuristic Teal Glow
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Community',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFFAFAFAF), // Soft Ash
                      ),
                    ),
                    // Profile Button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA7C7A1), // Healing Sage Green
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Welcome Message Card - matching home page style
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA7C7A1).withOpacity(0.2), // Light Healing Sage Green
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Hi, ${_userName ?? 'User'}!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2F2F2F), // Charcoal Grey
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('🌿', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFAFAFAF), // Soft Ash
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Community Help Card - matching home page style
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF27C2A4), // Futuristic Teal Glow
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Share Your Wellness Journey',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Connect with our Ayurvedic community. Share your dosha experiences, ask questions, and learn from others on their wellness path.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AskCommunityScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF27C2A4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Ask Community',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.people,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Community Posts Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community Discussions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 400, // Fixed height for posts section
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('community_posts')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color(0xFF27C2A4)), // Futuristic Teal Glow
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFAFAFAF).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.forum_outlined,
                                      color: const Color(0xFFAFAFAF),
                                      size: 40,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No discussions yet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF2F2F2F), // Charcoal Grey
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Be the first to start a wellness discussion!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFFAFAFAF), // Soft Ash
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          final posts = snapshot.data!.docs;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: posts.length,
                            itemBuilder: (context, index) =>
                                _buildPostCard(posts[index], context),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPostCard(DocumentSnapshot post, BuildContext context) {
    final postData = post.data() as Map<String, dynamic>;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReplyPage(
              postId: post.id,
              imageUrl: postData['imageUrl'],
              question: postData['question'],
              description: postData['description'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(post),
            _buildPostContent(post),
            _buildPostFooter(post),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(DocumentSnapshot post) {
    String userName = post['userName'] ?? 'Anonymous';
    String userProfileImage = post['userProfileImage'] ?? '';
    final postOwnerId = post['userId'] ?? '';
    final postId = post.id;

    // Get timestamp and format as "time ago"
    String timeAgo = '';
    final timestamp = post['timestamp'];
    if (timestamp != null) {
      final date = (timestamp as Timestamp).toDate();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) {
        timeAgo = '${difference.inSeconds}s ago';
      } else if (difference.inMinutes < 60) {
        timeAgo = '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        timeAgo = '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        timeAgo = '${difference.inDays}d ago';
      } else {
        timeAgo = '${date.day}/${date.month}/${date.year}';
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  backgroundImage: userProfileImage.isNotEmpty
                      ? NetworkImage(userProfileImage)
                      : null,
                  child: userProfileImage.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF27C2A4), // Futuristic Teal Glow
                                const Color(0xFFA7C7A1), // Healing Sage Green
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              userName[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      color: const Color(0xFF27C2A4), // Futuristic Teal Glow
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: const Color(0xFFAFAFAF), // Soft Ash
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: const Color(0xFFAFAFAF)), // Soft Ash
            onSelected: (value) async {
              final postData = post.data() as Map<String, dynamic>;
              final postUrl = 'https://yourapp.com/community/$postId';
              final shareText =
                  'Check out this post: ${postData['question']}\n$postUrl';

              if (value == 'share') {
                Share.share(shareText);
              } else if (value == 'delete') {
                // Confirm before deleting
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Post'),
                    content: Text('Are you sure you want to delete this post?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child:
                            Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await FirebaseFirestore.instance
                      .collection('community_posts')
                      .doc(postId)
                      .delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post deleted')),
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String>> items = [
                PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Share'),
                    ],
                  ),
                ),
              ];
              // Only show delete if current user is the owner
              if (FirebaseAuth.instance.currentUser?.uid == postOwnerId) {
                items.add(
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                );
              }
              return items;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(DocumentSnapshot post) {
    final imageUrl = post['imageUrl'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post['question'],
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16,
              color: const Color(0xFF2F2F2F), // Charcoal Grey
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post['description'],
            style: TextStyle(
              color: const Color(0xFFAFAFAF), // Soft Ash
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          if (imageUrl != null && imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: const Color(0xFFAFAFAF).withOpacity(0.1),
                  child: Center(
                    child: Icon(Icons.broken_image, color: const Color(0xFFAFAFAF)),
                  ),
                );
              },
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildPostFooter(DocumentSnapshot post) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('community_posts')
          .doc(post.id)
          .collection('votes')
          .doc(currentUserId)
          .get(),
      builder: (context, voteSnapshot) {
        final hasVoted = voteSnapshot.hasData && voteSnapshot.data!.exists;
        final voteType = hasVoted ? voteSnapshot.data!['type'] : null;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('community_posts')
              .doc(post.id)
              .collection('votes')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_up_outlined),
                          label: const Text('Like'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF27C2A4), // Futuristic Teal Glow
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_down_outlined),
                          label: const Text('Dislike'),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.grey),
                        ),
                      ],
                    ),
                    const Text(
                      'Loading...',
                      style: TextStyle(color: const Color(0xFFAFAFAF)), // Soft Ash
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_up_outlined),
                          label: const Text('Like'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF27C2A4), // Futuristic Teal Glow
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_down_outlined),
                          label: const Text('Dislike'),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      '0 answers',
                      style: TextStyle(color: const Color(0xFFAFAFAF)), // Soft Ash
                    ),
                  ],
                ),
              );
            }

            // Calculate total likes and dislikes
            int likes = 0;
            int dislikes = 0;
            for (final vote in snapshot.data!.docs) {
              if (vote['type'] == 'like') {
                likes++;
              } else if (vote['type'] == 'dislike') {
                dislikes++;
              }
            }

            int answersCount =
                (post.data() as Map<String, dynamic>)['answersCount'] ?? 0;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          if (currentUserId.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'You must be logged in to like a post')),
                            );
                            return;
                          }

                          final voteRef = FirebaseFirestore.instance
                              .collection('community_posts')
                              .doc(post.id)
                              .collection('votes')
                              .doc(currentUserId);

                          if (voteType == 'like') {
                            await voteRef.delete();
                          } else {
                            if (voteType == 'dislike') {
                              await voteRef.delete();
                            }
                            await voteRef.set({'type': 'like'});
                          }

                          final postOwnerId = post['userId'];
                          if (postOwnerId != currentUserId) {
                            await FirebaseFirestore.instance
                                .collection('notifications')
                                .add({
                              'recipientId': postOwnerId,
                              'senderId': currentUserId,
                              'message': 'Someone liked your post',
                              'postId': post.id,
                              'question': post['question'],
                              'description': post['description'],
                              'timestamp': FieldValue.serverTimestamp(),
                            });
                          }

                          setState(() {});
                        },
                        icon: Icon(
                          Icons.thumb_up_outlined,
                          color: voteType == 'like'
                              ? const Color(0xFF27C2A4) // Futuristic Teal Glow
                              : const Color(0xFFAFAFAF), // Soft Ash
                        ),
                        label: Text(
                          'Like ($likes)',
                          style: TextStyle(
                            color: voteType == 'like'
                                ? const Color(0xFF27C2A4) // Futuristic Teal Glow
                                : const Color(0xFFAFAFAF), // Soft Ash
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF27C2A4), // Futuristic Teal Glow
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () async {
                          if (currentUserId.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'You must be logged in to dislike a post')),
                            );
                            return;
                          }

                          final voteRef = FirebaseFirestore.instance
                              .collection('community_posts')
                              .doc(post.id)
                              .collection('votes')
                              .doc(currentUserId);

                          if (voteType == 'dislike') {
                            await voteRef.delete();
                          } else {
                            if (voteType == 'like') {
                              await voteRef.delete();
                            }
                            await voteRef.set({'type': 'dislike'});
                          }

                          final postOwnerId = post['userId'];
                          if (postOwnerId != currentUserId) {
                            await FirebaseFirestore.instance
                                .collection('notifications')
                                .add({
                              'recipientId': postOwnerId,
                              'senderId': currentUserId,
                              'message': 'Someone disliked your post',
                              'postId': post.id,
                              'question': post['question'],
                              'description': post['description'],
                              'timestamp': FieldValue.serverTimestamp(),
                            });
                          }

                          setState(() {});
                        },
                        icon: Icon(
                          Icons.thumb_down_outlined,
                          color: voteType == 'dislike'
                              ? const Color(0xFF27C2A4) // Futuristic Teal Glow
                              : const Color(0xFFAFAFAF), // Soft Ash
                        ),
                        label: Text(
                          'Dislike ($dislikes)',
                          style: TextStyle(
                            color: voteType == 'dislike'
                                ? const Color(0xFF27C2A4) // Futuristic Teal Glow
                                : const Color(0xFFAFAFAF), // Soft Ash
                          ),
                        ),
                        style:
                            TextButton.styleFrom(foregroundColor: const Color(0xFFAFAFAF)), // Soft Ash
                      ),
                    ],
                  ),
                  Text(
                    '$answersCount answers',
                    style: TextStyle(color: const Color(0xFFAFAFAF)), // Soft Ash
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
