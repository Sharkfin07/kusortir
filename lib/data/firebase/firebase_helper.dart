import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kusortir/data/models/item_model.dart';

class FirestoreHelper {
  FirestoreHelper();

  final itemRef = FirebaseFirestore.instance
      .collection("items")
      .withConverter<Item>(
        fromFirestore: (snapshots, _) => Item.fromJson(snapshots.data()!),
        toFirestore: (item, _) => item.toJson(),
      );

  // * Fungsi add item
  Future<String> addItem(Item item) async {
    final docRef = await itemRef.add(item);
    return docRef.id;
  }

  // * Fungsi get items (sekali ambil)
  Future<List<Item>> getAllItems() async {
    final dataSnapshot = await itemRef.get();
    return dataSnapshot.docs.map(_mapDoc).toList();
  }

  // * Stream perubahan item realtime
  Stream<List<Item>> watchItems() {
    return itemRef.snapshots().map(
      (snapshot) => snapshot.docs.map(_mapDoc).toList(),
    );
  }

  // * Stream single item detail
  Stream<Item?> watchItem(String documentId) {
    return itemRef.doc(documentId).snapshots().map((snapshot) {
      final item = snapshot.data();
      if (item == null) return null;
      item.documentId = snapshot.id;
      return item;
    });
  }

  // * Ambil item sekali
  Future<Item?> getItem(String documentId) async {
    final snapshot = await itemRef.doc(documentId).get();
    final item = snapshot.data();
    if (item == null) return null;
    item.documentId = snapshot.id;
    return item;
  }

  Item _mapDoc(QueryDocumentSnapshot<Item> doc) {
    final item = doc.data();
    item.documentId = doc.id;
    return item;
  }

  // * Fungsi menghapus item
  Future<void> removeItem(String documentId) async {
    await itemRef.doc(documentId).delete();
  }
}
