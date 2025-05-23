import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login/loading_screen.dart';
import 'restaurant_reviews_screen.dart';
import 'randomizer.dart';

class RestaurantsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 214, 98, 1.0),
              ),
              accountName: Text(''),
              accountEmail: Text(user?.email ?? 'Guest',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.black),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoadingScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '🛎️ Find Restaurants',
          style: TextStyle(color: Color.fromRGBO(0, 83, 156, 1.0), fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromRGBO(0, 83, 156, 1.0),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => randomizer()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Randomizer'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),

      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tbl_restaurants').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            final restaurants = snapshot.data!.docs;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Be the first to try these new restaurants',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                for (final doc in restaurants)
                  _RestaurantCard(doc: doc),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;

  const _RestaurantCard({required this.doc});

  Future<Map<String, dynamic>> _fetchRatings(String restaurantId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('restaurant_id', isEqualTo: restaurantId)
        .get();

    final reviews = snapshot.docs;
    if (reviews.isEmpty) return {'avg': 0.0, 'count': 0};

    final sum = reviews.fold<num>(0, (total, doc) => total + (doc['rating'] ?? 0));

    final avg = sum / reviews.length;

    return {'avg': avg, 'count': reviews.length};
  }

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final imageUrl = data['image'] ?? '';
    final name = data['name'] ?? 'Unnamed';
    final category = data['category'] ?? 'N/A';
    final price = data['price'] ?? '₱';
    final address = data['address'] ?? '';
    final restaurantId = data['restaurant_id']?.toString() ?? '';

    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchRatings(restaurantId),
      builder: (context, snapshot) {
        final avgRating = snapshot.data?['avg']?.toStringAsFixed(1) ?? '0.0';
        final reviewCount = snapshot.data?['count'] ?? 0;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RestaurantReviewsScreen(
                  restaurantId: restaurantId,
                  restaurantName: name,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.white60,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 160,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(category),
                      const SizedBox(height: 2),
                      Text(address, style: TextStyle(color: Colors.black)),
                      const SizedBox(height: 4),
                      Text(price, style: TextStyle(color: Colors.black87)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.star, size: 18, color: Colors.yellow[700]),
                          const SizedBox(width: 4),
                          Text(avgRating, style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Text('($reviewCount reviews)', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
