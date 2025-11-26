// lib/add_item_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'item.dart';


class AddItemPage extends StatefulWidget {
  final Item? itemToEdit;

  const AddItemPage({super.key, this.itemToEdit});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  late TextEditingController _itemController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  bool get isEditing => widget.itemToEdit != null;

  @override
  void initState() {
    super.initState();

    
    if (isEditing) {
      _itemController = TextEditingController(text: widget.itemToEdit!.name);
      _priceController = TextEditingController(text: _formatPriceForInput(widget.itemToEdit!.price));
      _quantityController = TextEditingController(text: widget.itemToEdit!.quantity.toString());
    } else {
      // Valores padrão para criação de novo item
      _itemController = TextEditingController();
      _priceController = TextEditingController();
      _quantityController = TextEditingController(text: '1');
    }
  }

  
  String _formatPriceForInput(double price) {
   
    final String formatted = NumberFormat('###0.00', 'pt_BR').format(price);
    return formatted.replaceAll('.', ',');
  }


  @override
  void dispose() {
    _itemController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _saveItem() {
    final itemName = _itemController.text.trim();
    final priceText = _priceController.text.replaceAll(',', '.');
    final quantityText = _quantityController.text.trim();

    if (itemName.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha nome e preço do item.')),
      );
      return;
    }

    final double? price = double.tryParse(priceText);
    final int? quantity = int.tryParse(quantityText);

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um preço válido.')),
      );
      return;
    }

   
    final resultItem = Item(
      name: itemName,
      price: price,
      quantity: quantity ?? 1,
      isCompleted: isEditing ? widget.itemToEdit!.isCompleted : false, 
    );

    
    Navigator.pop(context, resultItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing ? 'Editar Item' : 'Criar Item', 
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Icon(
                        Icons.shopping_cart,
                        size: 30,
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
               
                  const Text(
                    'Nome do Item',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      hintText: 'Ex: Maçãs, Detergente...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Preço Unitário',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildPriceField(),
                  const SizedBox(height: 30),
                  const Text(
                    'Quantidade (Opcional)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '1',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Botões
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                          ),
                          child: Text(
                            isEditing ? 'Salvar Edição' : 'Salvar Item', 
                            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text('R\$', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*[,]?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                hintText: '3,50',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}