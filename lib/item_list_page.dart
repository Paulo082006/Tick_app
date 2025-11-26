// lib/item_list_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'item.dart';
import 'add_item_page.dart';
import 'credits_page.dart'; 

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Item> _items = [];
  bool _isLoading = true;

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Métodos de Persistência 
  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsString = prefs.getString('shoppingList');

    if (itemsString != null) {
      final List<dynamic> jsonList = jsonDecode(itemsString);
      setState(() {
        _items = jsonList.map((json) => Item.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = _items.map((item) => item.toJson()).toList();
    await prefs.setString('shoppingList', jsonEncode(jsonList));
  }
  
  // Métodos de Ação 
  void _toggleItemCompletion(int index) {
    setState(() {
      _items[index].isCompleted = !_items[index].isCompleted;
    });
    _saveItems();
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _saveItems();
  }

  // Função para Adicionar Item 
  void _navigateToAddItem() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddItemPage()),
    );

    if (newItem != null && newItem is Item) {
      setState(() {
        _items.add(newItem);
      });
      _saveItems();
    }
  }

  // Função para Editar Item 
  void _navigateToEditItem(int index) async {
    final Item? editedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemPage(itemToEdit: _items[index]),
      ),
    );

    if (editedItem != null) {
      setState(() {
        _items[index] = editedItem;
      });
      _saveItems(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${editedItem.name} salvo com sucesso!')),
      );
    }
  }
  
  void _navigateToCreditsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreditsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Tick App',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.red),
        elevation: 1, 
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, size: 30),
            onPressed: _navigateToCreditsPage, 
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),

            child: Column(
              children: [
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _items.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum item na lista ainda.\nAdicione um novo!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                final item = _items[index];
                                
                                return Dismissible(
                                  key: ValueKey(item.name + item.price.toString() + index.toString()),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: const Icon(Icons.delete, color: Colors.white),
                                  ),
                                  confirmDismiss: (direction) {
                                    return Future.value(true);
                                  },
                                  onDismissed: (direction) {
                                    _removeItem(index);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${item.name} removido da lista.')),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        onTap: () => _navigateToEditItem(index), 
                                        contentPadding: EdgeInsets.zero,
                                        leading: GestureDetector(
                                          onTap: () => _toggleItemCompletion(index),
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: item.isCompleted ? Colors.green : Colors.transparent,
                                              border: Border.all(
                                                color: item.isCompleted ? Colors.green : Colors.grey,
                                                width: 2,
                                              ),
                                            ),
                                            child: item.isCompleted
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 16,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        title: Text(
                                          item.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            decoration: item.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                                            color: item.isCompleted ? Colors.grey : Colors.black87,
                                          ),
                                        ),
                                        subtitle: item.quantity > 1 ? Text('Qtd: ${item.quantity}', style: const TextStyle(color: Colors.grey)) : null,
                                        trailing: Text(
                                          _currencyFormat.format(item.price * item.quantity),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: item.isCompleted ? Colors.grey : Colors.black87,
                                          ),
                                        ),
                                      ),
                                      if (index < _items.length - 1)
                                        const Divider(height: 1, color: Colors.grey),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: _navigateToAddItem,
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.add, color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}