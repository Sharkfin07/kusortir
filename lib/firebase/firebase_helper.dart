import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kusortir/models/item_model.dart';

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
