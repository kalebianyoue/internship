import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:untitled/services_detail.dart';
import 'dart:io';
 // Import your BookingData class

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Add a new booking to Firestore
  Future<String> addBooking(BookingData bookingData) async {
    try {
      // Upload image first if it exists
      if (bookingData.workImage != null) {
        String imageUrl = await uploadImage(bookingData.workImage!);
        bookingData.imageUrl = imageUrl;
      }

      // Add booking data to Firestore
      DocumentReference docRef = await _firestore
          .collection('bookings')
          .add(bookingData.toMap());

      return docRef.id; // Return the document ID
    } catch (e) {
      print('Error adding booking: $e');
      throw Exception('Failed to add booking: $e');
    }
  }

  // Upload image to Firebase Storage
  Future<String> uploadImage(File imageFile) async {
    try {
      // Create a unique filename
      String fileName = 'booking_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Get reference to the file location
      Reference storageRef = _storage.ref().child(fileName);

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  // Get all bookings from Firestore
  Stream<List<BookingData>> getBookings() {
    return _firestore
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BookingData.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get a specific booking by ID
  Future<BookingData> getBooking(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('bookings').doc(id).get();

      if (doc.exists) {
        return BookingData.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        throw Exception('Booking not found');
      }
    } catch (e) {
      print('Error getting booking: $e');
      throw Exception('Failed to get booking: $e');
    }
  }

  // Update an existing booking
  Future<void> updateBooking(BookingData bookingData) async {
    try {
      // Upload new image if it exists and hasn't been uploaded yet
      if (bookingData.workImage != null && bookingData.imageUrl.isEmpty) {
        String imageUrl = await uploadImage(bookingData.workImage!);
        bookingData.imageUrl = imageUrl;
      }

      // Remove the workImage before saving to Firestore as it's not serializable
      Map<String, dynamic> data = bookingData.toMap();

      await _firestore
          .collection('bookings')
          .doc(bookingData.id)
          .update(data);
    } catch (e) {
      print('Error updating booking: $e');
      throw Exception('Failed to update booking: $e');
    }
  }

  // Delete a booking
  Future<void> deleteBooking(String id) async {
    try {
      await _firestore.collection('bookings').doc(id).delete();
    } catch (e) {
      print('Error deleting booking: $e');
      throw Exception('Failed to delete booking: $e');
    }
  }

  // Get bookings by user phone number
  Stream<List<BookingData>> getBookingsByPhone(String phoneNumber) {
    return _firestore
        .collection('bookings')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BookingData.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  }
