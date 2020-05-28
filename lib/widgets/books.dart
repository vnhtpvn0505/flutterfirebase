import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Books {
  String title;
  String descriptions;

  Books(this.title, this.descriptions);

  Books.map(dynamic books) {
    this.title = books['title'];
    this.descriptions = books['descriptions'];
  }

  Books.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        descriptions = snapshot['descriptions'];

  toJson() {
    return {"title": title, "descriptions": descriptions};
  }
}
