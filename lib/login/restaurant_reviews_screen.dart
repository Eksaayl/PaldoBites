import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RestaurantReviewsScreen extends StatelessWidget {
  final String restaurantId;
  final String restaurantName;

  const RestaurantReviewsScreen({
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    print('Restaurant ID: $restaurantId');

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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('restaurant_id', isEqualTo: restaurantId)
        // Temporarily remove orderBy until index is created
        // .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No reviews yet."));
          }

          final reviews = snapshot.data!.docs;
          print('Found ${reviews.length} reviews');

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final data = reviews[index].data() as Map<String, dynamic>;

              final username = "User ${data['user_id'] ?? 'Anonymous'}";
              final rating = int.tryParse(data['rating'].toString()) ?? 0;
              final comment = data['content'] ?? '';
              final date = (data['timestamp'] != null)
                  ? DateFormat.yMMMMd().add_jm().format(
                (data['timestamp'] as Timestamp).toDate(),
              )
                  : "Unknown date";

              return _ReviewCard(
                username: username,
                rating: rating,
                date: date,
                comment: comment,
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
