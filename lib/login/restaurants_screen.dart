import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login/loading_screen.dart';
import 'restaurant_reviews_screen.dart';

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
              accountName: Text(''),
              accountEmail: Text(user?.email ?? 'Guest'),
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
          'New restaurants',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Grocery'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tbl_restaurants').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No restaurants available."));
            }

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
                  _RestaurantCard(resto: doc.data() as Map<String, dynamic>),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> resto;

  const _RestaurantCard({required this.resto});

  @override
  Widget build(BuildContext context) {
    final imageUrl = resto['image'] ?? '';
    final name = resto['name'] ?? 'Unnamed';
    final price = resto['time'] ?? '15-30 min';
    final category = resto['category'] ?? 'N/A';
    final fee = resto['fee'] ?? '₱0';
    final promo = resto['promo'];
    final discount = resto['discount'];
    final tag = resto['tag'];
    final address = resto['address'] ?? '';
    final rating = resto['ratings']?.toDouble() ?? 0.0;
    final reviewCount = resto['reviews_count'] ?? 0;
    final restaurantId = resto['restaurant_id']?.toString() ?? '';

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
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('$price • $category'),
                  const SizedBox(height: 2),
                  Text(address, style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 4),
                  Text(fee, style: TextStyle(color: Colors.black87)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, size: 18, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text('$rating', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text('($reviewCount reviews)', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (promo != null) _PromoChip(promo, Icons.local_offer, Colors.pink),
                      if (discount != null) _PromoChip(discount, Icons.percent, Colors.deepOrange),
                    ],
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

class _PromoChip extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _PromoChip(this.text, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text, style: TextStyle(color: Colors.white)),
      avatar: Icon(icon, color: Colors.white, size: 18),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
