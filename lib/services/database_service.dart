import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';
import '../../models/refund_request.dart';
import '../../models/userRegistration.dart';

const String COLLECTION_REF_USER = "user";
const String COLLECTION_REF_REGISTER = "passenger";
const String COLLECTION_REF_LOGIN = "login";

class DatabaseService<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<T> _ref;

  DatabaseService(String collectionPath, T Function(Map<String, Object?> json) fromJson, Map<String, Object?> Function(T object) toJson) {
    _ref = _firestore.collection(collectionPath).withConverter<T>(
      fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
      toFirestore: (object, _) => toJson(object),
    );
  }

  FirebaseFirestore get firestore => _firestore;

  Stream<QuerySnapshot<T>> getSnapshots() {
    return _ref.snapshots();
  }

  //Future<void> add(T object) async {
  //try {
  //await _ref.add(object);
  //} catch (e) {
  //print("Error adding object: $e");
  //}
  //}
  Future<DocumentReference<T>> add(T object) async {
    try {
      return await _ref.add(object);
    } catch (e) {
      print("Error adding object: $e");
      rethrow;
    }
  }

  Future<void> setWithId(String id, T object) async {
    try {
      await _ref.doc(id).set(object);
    } catch (e) {
      print("Error setting object with id: $e");
    }
  }

  Future<T?> getByField(String field, String value) async {
    try {
      QuerySnapshot<T> snapshot = await _ref.where(field, isEqualTo: value).limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching object: $e");
      return null;
    }
  }
}

// Usage for User
final userService = DatabaseService<User>(
  COLLECTION_REF_USER,
      (json) => User.fromJson(json),
      (user) => user.toJson(),
);

// Usage for UserRegistration
final registerService = DatabaseService<UserRegistration>(
  COLLECTION_REF_REGISTER,
      (json) => UserRegistration.fromJson(json),
      (register) => register.toJson(),
);

// Usage for Login
final loginService = DatabaseService<User>(
  COLLECTION_REF_LOGIN,
      (json) => User.fromJson(json),
      (user) => user.toJson(),
);

const String COLLECTION_REF_REFUND_REQUEST = "refund_requests";

final refundRequestService = DatabaseService<RefundRequest>(
  COLLECTION_REF_REFUND_REQUEST,
      (json) => RefundRequest.fromJson(json),
      (refundRequest) => refundRequest.toJson(),
);