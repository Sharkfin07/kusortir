import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kusortir/models/item_model.dart';

class FirestoreHelper {
  final itemRef = FirebaseFirestore.instance
      .collection("items")
      .withConverter<Item>(
        fromFirestore: (snapshots, _) => Item.fromJson(snapshots.data()!),
        toFirestore: (item, _) => item.toJson(),
      );

  // * Fungsi add item
  Future addItem(Item item) async {
    final docRef = await itemRef.add(item);
    return docRef.id;
  }

  // * Fungsi get items
  Future<List<Item>> getAllItems() async {
    final dataSnapshot = await itemRef.get();
    return dataSnapshot.docs.map((doc) {
      final note = doc.data();
      note.itemId = doc.id as int;
      return note;
    }).toList();
  }

  // * Fungsi menghapus item
  Future<void> removeItem(String itemId) async {
    await itemRef.doc(itemId).delete();
  }
}
