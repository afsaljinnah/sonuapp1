import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/api_service.dart';

class ItemProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  List<Item> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _apiService.fetchItems();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(Item item) async {
    try {
      final newItem = await _apiService.createItem(item);
      _items.add(newItem);
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateItem(Item item) async {
    try {
      await _apiService.updateItem(item);
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _apiService.deleteItem(id);
      _items.removeWhere((item) => item.id == id);
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
