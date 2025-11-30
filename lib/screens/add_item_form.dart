import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kusortir/firebase/firebase_helper.dart';
import 'package:kusortir/models/item_model.dart';
import 'package:kusortir/widgets/kusortir_logo.dart';

class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _itemIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _supplierController = TextEditingController();
  final _weightController = TextEditingController();
  final _stockController = TextEditingController();
  DateTime _receivedAt = DateTime.now();
  bool _submitting = false;

  final _firestore = FirestoreHelper();

  @override
  void dispose() {
    _itemIdController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _supplierController.dispose();
    _weightController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _receivedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _receivedAt = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final item = Item(
        itemId: int.parse(_itemIdController.text.trim()),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        supplier: _supplierController.text.trim(),
        weight: int.parse(_weightController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        receivedAt: _receivedAt.toIso8601String(),
      );
      await _firestore.addItem(item);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item berhasil ditambahkan.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan item: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SmallLogo(text: "Kutambah")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNumberField(
                  controller: _itemIdController,
                  label: 'ID Item',
                  helper: 'Masukkan angka unik untuk item',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _nameController,
                  label: 'Nama Item',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _supplierController,
                  label: 'Supplier',
                ),
                const SizedBox(height: 12),
                _buildNumberField(
                  controller: _weightController,
                  label: 'Berat (kg)',
                ),
                const SizedBox(height: 12),
                _buildNumberField(controller: _stockController, label: 'Stock'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tanggal diterima',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat('dd MMM yyyy').format(_receivedAt),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Pilih tanggal'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // * Field khusus untuk menerima String
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Harus diisi';
        }
        return null;
      },
    );
  }

  // * Field khusus untuk menerima number
  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    String? helper,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, helperText: helper),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Harus diisi';
        }
        if (int.tryParse(value.trim()) == null) {
          return 'Masukkan angka valid';
        }
        return null;
      },
    );
  }
}
