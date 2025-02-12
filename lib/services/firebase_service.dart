import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mbap_project_part_2/models/myrecord.dart';
import 'package:path/path.dart';


// CREATE
class FirebaseService {
  Future<void> addRecord(
      String imageUrl, String name, int duration, DateTime usageDate) {
    return FirebaseFirestore.instance.collection('records').add({
      'imageUrl': imageUrl,
      'email': getCurrentUser()!.email,
      'name': name,
      'duration': duration,
      'usageDate': usageDate
    });
  }
// READ
  Stream<List<MyRecord>> getRecord() {
    return FirebaseFirestore.instance
        .collection('records')
        .where('email', isEqualTo: getCurrentUser()!.email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MyRecord(
                id: doc.id,
                imageUrl: doc.data()['imageUrl'] ?? '',
                duration: doc.data()['duration'],
                name: doc.data()['name'] ?? '',
                usageDate:
                    (doc.data()['usageDate'] ?? DateTime.now() as Timestamp)
                        .toDate()))
            .toList());
  }
//UPDATE
  Future<void> updateRecord(
    String imageUrl,
    String id,
    int duration,
    String name,
    DateTime usageDate,
  ) {
    return FirebaseFirestore.instance.collection('records').doc(id).update({
      'imageUrl': imageUrl,
      'name': name,
      'duration': duration,
      'usageDate': usageDate,
    });
  }


  //DELETE

  Future<void> deleteRecord(String id) {
    return FirebaseFirestore.instance.collection('records').doc(id).delete();
  }


// READ with conditon
  Stream<List<MyRecord>> getRecordsWithCondition() {
    return FirebaseFirestore.instance
        .collection('records')
        .where('duration', isGreaterThan: 100)
        .orderBy('duration', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MyRecord(
                id: doc.id,
                imageUrl: doc.data()['imageUrl'] ?? '',
                duration: doc.data()['duration'],
                name: doc.data()['name'] ?? '',
                usageDate:
                    (doc.data()['usageDate'] ?? DateTime.now() as Timestamp)
                        .toDate()))
            .toList());
  }
// more conditions
  Stream<List<MyRecord>> getRecordsWithMultipleCondition() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    return FirebaseFirestore.instance.collection('records').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => MyRecord(
                  id: doc.id,
                  imageUrl: doc.data()['imageUrl'] ?? '',
                  duration: doc.data()['duration'],
                  name: doc.data()['name'] ?? '',
                  usageDate: (doc.data()['usageDate'] as Timestamp).toDate(),
                ))
            .where((record) =>
                record.duration > 100 &&
                record.usageDate.year == today.year &&
                record.usageDate.month == today.month &&
                record.usageDate.day == today.day)
            .toList());
  }


  // authentication

  Future<UserCredential> register(email, password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> login(email, password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> forgotPassword(email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Stream<User?> getAuthUser() {
    return FirebaseAuth.instance.authStateChanges();
  }

  Future<void> logOut() {
    return FirebaseAuth.instance.signOut();
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  //change apssword

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {  //make sure user is first authenticated
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // Proceed with changing the password
        await user.updatePassword(newPassword);
        print("Password updated successfully.");
      } catch (e) {
        print("Error updating password: $e");
        throw e; 
      }
    } else {
      throw Exception("No user is currently signed in.");
    }
  }




  Future<void> addProfileImage(File? profilePicture) async {
    final currentUserEmail = getCurrentUser()?.email;
    if (currentUserEmail == null) return;

    if (profilePicture != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(currentUserEmail);
      UploadTask uploadTask = storageRef.putFile(profilePicture);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadURL = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("ProfilePicture")
          .doc(currentUserEmail)
          .set({"profilePicture": downloadURL});
    } else {
      await FirebaseFirestore.instance
          .collection("ProfilePicture")
          .doc(currentUserEmail)
          .delete();
    }
  }

  Future<String?> getProfileImageURL() async {
    final currentUserEmail = getCurrentUser()?.email;
    if (currentUserEmail == null) return null;

    final docSnapshot = await FirebaseFirestore.instance
        .collection("ProfilePicture")
        .doc(currentUserEmail)
        .get();

    if (docSnapshot.exists) {
      return docSnapshot['profilePicture'] as String?;
    }
    return null;
  }

  Future<String?> getProfileImage() async {
    final currentUserEmail = getCurrentUser()?.email;
    if (currentUserEmail == null) return null;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("ProfilePicture")
        .doc(currentUserEmail)
        .get();
    if (snapshot.exists) {
      return snapshot['profilePicture'];
    }
    return null;
  }

  User? getUserProfile() {
    return FirebaseAuth.instance.currentUser;
  }


// image & gallery storage for the applicance when making a record / update
  Future<String?> addAppliancePhoto(File appliancePhoto) {
    return FirebaseStorage.instance
        .ref()
        .child(DateTime.now().toString() + '_' + basename(appliancePhoto.path))
        .putFile(appliancePhoto)
        .then((task) {
      return task.ref.getDownloadURL().then((imageUrl) {
        return imageUrl;
      });
    });
  }
}
