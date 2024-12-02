import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Feedbacks(),
  ),
);

class Feedbacks extends StatefulWidget {
  const Feedbacks({super.key});

  @override
  State<Feedbacks> createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserEmail(); // Fetch user's email when the widget initializes
  }

  Future<void> _fetchUserEmail() async {
    try {
      // Example: Replace with current user's ID or authentication mechanism
      final currentUserUid = "example_user_uid"; // Use real UID from FirebaseAuth

      final passengerDoc =
      await _firestore.collection('passenger').doc(currentUserUid).get();

      if (passengerDoc.exists) {
        setState(() {
          _userEmail = passengerDoc['email'];
        });
        print('User email fetched: $_userEmail');
      } else {
        print('No passenger document found for UID: $currentUserUid');
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: FeedbackForm(), // Use the FeedbackForm widget as the dialog's content
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews and Feedbacks"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 230, 81, 0),
                Color.fromRGBO(239, 108, 0, 1),
                Color.fromRGBO(255, 167, 38, 1),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Display Top 5 Feedbacks
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: _firestore
                  .collection('feedback')
                  .orderBy('type', descending: true) // Order by rating/type
                  .limit(5) // Fetch only top 5 feedbacks
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No feedbacks available."));
                }

                final feedbacks = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: feedbacks.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbacks[index];
                    final rating = feedback['type'] as double? ?? 0.0;
                    final comment = feedback['note'] as String? ?? "No comment";

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display Rating
                            RatingBar(
                              filledIcon: Icons.star,
                              emptyIcon: Icons.star_border,
                              initialRating: rating,
                              filledColor: const Color.fromARGB(255, 229, 199, 66),
                              emptyColor: Colors.grey,
                              size: 30,
                              maxRating: 5,
                              isHalfAllowed: false,
                              onRatingChanged: (value) {},
                            ),
                            const SizedBox(height: 10),
                            // Display Comment
                            Text(
                              comment,
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Move "Give Feedback" button lower
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 69, 230, 1),
                    Color.fromRGBO(0, 115, 239, 1),
                    Color.fromRGBO(38, 201, 255, 1),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ElevatedButton(
                onPressed: () => _showFeedbackDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Give Feedback",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          )
          ,
        ],
      ),
    );
  }
}

// FeedbackForm remains unchanged (use your previous code)


class FeedbackForm extends StatefulWidget {
  final String? userEmail;

  const FeedbackForm({super.key, this.userEmail});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitFeedback() async {
    // Replace this with the user's email
    final String userEmail = 'testuser@example.com';

    try {
      await _firestore.collection('feedback').add({
        'details': 'Feedback for E-Shuttle',
        'note': _commentController.text.trim(),
        'open': false, // Default false
        'read': false, // Default false
        'title': 'E-Shuttle Feedback',
        'type': _rating, // Rating number
        'userId': userEmail, // User's email
      });

      print('Feedback submitted successfully.');
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      print('Error submitting feedback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered Title
            Text(
              'Rate your experience with E-Shuttle',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 25),

            // Centered Star Ratings
            Center(
              child: RatingBar(
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
                filledColor: const Color.fromARGB(255, 229, 199, 66),
                emptyColor: Colors.grey,
                size: 40,
                initialRating: 0,
                maxRating: 5,
                isHalfAllowed: false, // Half ratings are disabled
              ),
            ),
            const SizedBox(height: 25),

            // Comment Box
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Additional comment',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Cancel and Submit Buttons with Gradient
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // Submit Button
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 69, 230, 1),
                        Color.fromRGBO(0, 115, 239, 1),
                        Color.fromRGBO(38, 201, 255, 1),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: _submitFeedback, // Submit feedback to Firestore
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
