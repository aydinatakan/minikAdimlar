import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';

class HomeProvider extends ChangeNotifier {
  List<Reminder> _reminders = [];
  List<String> _quickAccessModules = [
    'Görsel Eşleştirme',
    'Hikaye Dinleme',
  ];

  List<Reminder> get reminders => _reminders;
  List<String> get quickAccessModules => _quickAccessModules;

  HomeProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Reminders
    final String? remindersJson = prefs.getString('user_reminders');
    if (remindersJson != null) {
      final List<dynamic> decoded = jsonDecode(remindersJson);
      _reminders = decoded.map((item) => Reminder.fromMap(item)).toList();
    }

    // Load Quick Access Modules
    final List<String>? modules = prefs.getStringList('quick_access_modules');
    if (modules != null) {
      _quickAccessModules = modules;
    }
    
    notifyListeners();
  }

  Future<void> saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_reminders.map((r) => r.toMap()).toList());
    await prefs.setString('user_reminders', encoded);
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    _reminders.add(reminder);
    await saveReminders();
  }

  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    await saveReminders();
  }

  Future<void> updateQuickAccessModules(List<String> modules) async {
    _quickAccessModules = modules;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('quick_access_modules', modules);
    notifyListeners();
  }
}
