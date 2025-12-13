import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kusortir/data/firebase/firebase_helper.dart';
import 'package:kusortir/data/models/item_model.dart';
import 'package:kusortir/widgets/kusortir_logo.dart';

class ItemDetailArguments {
  const ItemDetailArguments({required this.documentId, this.initialItem});

  final String documentId;
  final Item? initialItem;
}

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final _firestore = FirestoreHelper();
  ItemDetailArguments? _args;
  bool _isDeleting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args ??=
        ModalRoute.of(context)?.settings.arguments as ItemDetailArguments?;
  }

  Future<void> _deleteItem(Item item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus item?'),
        content: Text('Item "${item.name}" akan dihapus secara permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isDeleting = true);
    try {
      await _firestore.removeItem(item.documentId!);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Item "${item.name}" dihapus.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus item: $e')));
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = _args;
    if (args == null || args.documentId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Item tidak ditemukan: argumen hilang.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const SmallLogo(text: "Kudetail"),
        actions: [
          if (!_isDeleting)
            IconButton(
              tooltip: 'Hapus',
              onPressed: () {
                final current = _currentItem;
                if (current != null && current.documentId != null) {
                  _deleteItem(current);
                }
              },
              icon: const Icon(Icons.delete_outline),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: StreamBuilder<Item?>(
        stream: _firestore.watchItem(args.documentId),
        initialData: args.initialItem,
        builder: (context, snapshot) {
          final item = snapshot.data;
          _currentItem = item;

          if (snapshot.connectionState == ConnectionState.waiting &&
              item == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (item == null) {
            return const Center(
              child: Text('Item tidak ditemukan atau telah dihapus.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _DetailHeader(item: item),
              const SizedBox(height: 24),
              _InfoRow(label: 'Supplier', value: item.supplier),
              _InfoRow(label: 'Berat (kg)', value: item.weight.toString()),
              _InfoRow(label: 'Stok', value: item.stock.toString()),
              _InfoRow(
                label: 'Tanggal diterima',
                value: DateFormat(
                  'dd MMM yyyy',
                ).format(DateTime.parse(item.receivedAt)),
              ),
              _InfoRow(label: 'ID Item', value: item.itemId.toString()),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Deskripsi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Item? _currentItem;
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Supplier: ${item.supplier}',
            style: TextStyle(color: colors.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
