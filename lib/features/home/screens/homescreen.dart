import 'package:flutter/material.dart';
import 'package:kusortir/data/firebase/firebase_helper.dart';
import 'package:kusortir/data/models/item_model.dart';
import 'package:kusortir/widgets/item.dart';
import 'package:kusortir/features/item/screens/item_detail.dart';
import 'package:kusortir/widgets/kusortir_logo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kusortir/features/authentication/bloc/auth_bloc.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final _firestore = FirestoreHelper();

  Future<void> _handleDelete(Item item) async {
    final docId = item.documentId;
    if (docId == null) return;
    await _firestore.removeItem(docId);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Item "${item.name}" dihapus')));
  }

  void _handleSignOut() {
    context.read<AuthBloc>().add(SignOutEvent());
  }

  Future<void> _handleAddItem() async {
    final result = await Navigator.of(context).pushNamed('/add-item');
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item baru telah ditambahkan.')),
      );
    }
  }

  void _openDetail(Item item) {
    final docId = item.documentId;
    if (docId == null) return;
    Navigator.of(context).pushNamed(
      '/item-detail',
      arguments: ItemDetailArguments(documentId: docId, initialItem: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          Navigator.of(context).pushReplacementNamed('/sign-in');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final email = state is AuthSignedUp ? state.email : '';
              return Row(
                children: [
                  const SmallLogo(text: "Kucek"),
                  if (email.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(email, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ],
              );
            },
          ),
          leading: null,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              tooltip: 'Logout',
              onPressed: _handleSignOut,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _handleAddItem,
          icon: const Icon(Icons.add),
          label: const Text('Tambah'),
        ),
        body: SafeArea(
          child: StreamBuilder<List<Item>>(
            stream: _firestore.watchItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'),
                );
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) {
                return const _EmptyState();
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await _firestore.getAllItems();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ItemCard(
                      item: item,
                      onTap: () => _openDetail(item),
                      onDelete: () => _handleDelete(item),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 64),
          const SizedBox(height: 16),
          Text(
            'Belum ada data inventaris',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text('Tekan tombol Tambah untuk memasukkan item baru'),
        ],
      ),
    );
  }
}
