import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  late CollectionReference notesDynamic;
  //get data from the 2firestore
  initializeDatabase(String name) {
    notesDynamic = FirebaseFirestore.instance.collection(name);
  }

  final CollectionReference notes =
      FirebaseFirestore.instance.collection("vents");

  final CollectionReference notes2 =
      FirebaseFirestore.instance.collection("users");

  //Create: add note to the fire store
  Future<void> add( String venterId, String venterEmail, String message) {
    return notes.add({
     "venterId": venterId,
      'venterEmail': venterEmail,
      'ventMessage': message,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> addDynaic(
      String venterId, String venterEmail, int price, String message) {
    return notesDynamic.add({
      "venterId": venterId,
      'venterEmail': venterEmail,
      'ventMessage': message,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> addTry(
    String imageName,
  ) {
    return notes.add({"note": imageName, 'timestamp': Timestamp.now()});
  }

  //Retrive: brings up note from the fire store
  Stream<QuerySnapshot> getNotes() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  Stream<QuerySnapshot> getUsers() {
    final notesStream =
        notes2.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  Stream<QuerySnapshot> getNotesDynamic() {
    final notesStream =
        notesDynamic.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //Update: edit notes with a provided doc id
  Future<void> updateNote(String docId, String imageName, String name,
      String price, String description) {
    return notes.doc(docId).update({
      'imageName': imageName,
      'name': name,
      'price': price,
      'discription': description,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> updateNoteDynamic(String docId, String imageName, String name,
      String price, String description) {
    return notesDynamic.doc(docId).update({
      'imageName': imageName,
      'name': name,
      'price': price,
      'discription': description,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> updateNoteTry(
    String docId,
    String imageName,
  ) {
    return notes.doc(docId).update({
      'note': imageName,
      // 'name': name,
      // 'price': price,
      // 'discription': description,
      // 'timestamp': Timestamp.now()
    });
  }

  //Delete: delete notes with a provided doc id
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }

  Future<void> deleteNoteDynamic(String docID) {
    return notesDynamic.doc(docID).delete();
  }

Future<String?> searchUserUIDByEmail(String email) async {
  try {
    // Create a reference to the Firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Query for documents where the email field matches the provided email
    QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document (assuming emails are unique)
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      
      // Retrieve the UID from the document
      String? uid = userDoc.get('verificationCode'); // Replace 'UID' with the actual field name in your Firestore document

      // Return the UID
      return uid;
    } else {
      // No matching document found
      return null;
    }
  } catch (e) {
    // Handle any errors
    print('Error searching user UID by email: $e');
    return null;
  }
}

}


