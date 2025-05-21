import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RestaurantReviewsScreen extends StatelessWidget {
  final String restaurantId;
  final String restaurantName;

  const RestaurantReviewsScreen({
    required this.restaurantId,
    required this.restaurantName,
  });

  Future<String> _getUsername(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null && data['username'] != null) {
          return data['username'] as String;
        }
      }
      return 'Anonymous';
    } catch (e) {
      return 'Anonymous';
    }
  }


  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: BackButton(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ratings & Reviews", style: TextStyle(color: Colors.black, fontSize: 16)),
            Text(restaurantName, style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        actions: [
          if (currentUser != null)
            IconButton(
              icon: Icon(Icons.rate_review, color: Colors.black),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _ReviewDialog(restaurantId: restaurantId),
                );
              },
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('restaurant_id', isEqualTo: restaurantId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No reviews yet."));
          }

          final reviews = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final data = reviews[index].data() as Map<String, dynamic>;
              final userId = data['user_id'] ?? '';
              final rating = int.tryParse(data['rating'].toString()) ?? 0;
              final comment = data['content'] ?? '';
              final date = (data['timestamp'] as Timestamp).toDate();

              return FutureBuilder<String>(
                future: _getUsername(userId),
                builder: (context, snapshot) {
                  final username = snapshot.data ?? 'Loading...';
                  return _ReviewCard(
                    username: username,
                    rating: rating,
                    date: DateFormat.yMMMMd().add_jm().format(date),
                    comment: comment,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String username;
  final int rating;
  final String date;
  final String comment;

  const _ReviewCard({
    required this.username,
    required this.rating,
    required this.date,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Row(
                  children: List.generate(
                    rating,
                        (_) => Icon(Icons.star, color: Colors.orange, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(date, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(comment),
          ],
        ),
      ),
    );
  }
}

class _ReviewDialog extends StatefulWidget {
  final String restaurantId;

  const _ReviewDialog({required this.restaurantId});

  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<_ReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;

  final List<String> _ratingLabels = [
    "Terrible", "Bad", "Okay", "Good", "Excellent"
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Review", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  _selectedRating > 0 ? _ratingLabels[_selectedRating - 1] : '',
                  style: TextStyle(fontSize: 16, color: Colors.orange),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: _selectedRating > index ? Colors.orange : Colors.grey[300],
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Please share your experience with us ...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Review cannot be empty' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      if (_formKey.currentState!.validate() && _selectedRating > 0) {
                        final review = {
                          'restaurant_id': widget.restaurantId,
                          'rating': _selectedRating,
                          'content': _commentController.text.trim(),
                          'timestamp': Timestamp.now(),
                          'user_id': user.uid,
                        };

                        await FirebaseFirestore.instance.collection('reviews').add(review);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill in all fields.")),
                        );
                      }
                    },
                    child: Text("Submit Review", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
