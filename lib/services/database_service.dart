import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unitled2/models/user.dart';

const String COLLECTION_REF = "user";

class DatabaseService{
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _userRef;

  DatabaseService(){
    _userRef = _firestore.collection(COLLECTION_REF).withConverter<User>(fromFirestore: (snapshots, _)=> User.fromJson(snapshots.data()!,), toFirestore: (user, _)=>user.toJson());
  }

  Stream<QuerySnapshot>getUser(){
    return _userRef.snapshots();
  }

  void addUser(User user) async {
    _userRef.add(user);
  }

  // Method to get user by email or Student ID
  Future<User?> getUserByEmailOrStudentID(String emailOrStudentID) async {
    try {
      // Query Firestore for user with provided email or Student ID
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(COLLECTION_REF)
          .where('email_student_id', isEqualTo: emailOrStudentID)
          .limit(1)
          .get();

      // Check if user exists
      if (snapshot.docs.isNotEmpty) {
        // Convert the document snapshot to a User object
        return User.fromJson(snapshot.docs.first.data());
      } else {
        // User not found
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  // Method to add a user document to Firestore
  Future<void> addUsertoDB(User user) async {
    try {
      // Add user document to Firestore
      await _firestore.collection(COLLECTION_REF).add(user.toJson());
    } catch (e) {
      print("Error adding user: $e");
    }
  }


}