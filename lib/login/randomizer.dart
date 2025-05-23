import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class randomizer extends StatefulWidget {
  @override
  _randomizerState createState() => _randomizerState();
}

class _randomizerState extends State<randomizer> {
  Map<String, dynamic>? selectedRestaurant;

  Future<void> getRandomRestaurant() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('tbl_restaurants').get();
    final restaurants = snapshot.docs;

    if (restaurants.isNotEmpty) {
      final random = Random();
      final randomDoc = restaurants[random.nextInt(restaurants.length)];
      setState(() {
        selectedRestaurant = randomDoc.data();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRandomRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🎲 Food Randomizer',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(0, 83, 156, 1.0),
      ),
      body: selectedRestaurant == null
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                "Can't decide? Try shuffling!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 83, 156, 1.0),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Tap the shuffle button to explore random restaurants you might like!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),

              // Card
              Card(
                color: Color.fromRGBO(255, 214, 98, 1.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedRestaurant!['image'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            selectedRestaurant!['image'],
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: 12),
                      Text(
                        selectedRestaurant!['name'] ?? 'No name',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        selectedRestaurant!['category'] ?? '',
                        style: TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        selectedRestaurant!['address'] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Color.fromRGBO(0, 83, 156, 1.0),
                        ),
                        onPressed: getRandomRestaurant,
                        icon: Icon(Icons.shuffle, color: Colors.white),
                        label: Text(
                          'Shuffle Again',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
