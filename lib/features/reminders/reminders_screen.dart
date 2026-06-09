import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../services/notification_service.dart';
import '../../services/home_provider.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _addReminder(String title, String content, DateTime dateTime) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final newReminder = Reminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      dateTime: dateTime,
    );

    homeProvider.addReminder(newReminder);
    
    // Schedule notification
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    notificationService.scheduleNotification(
      id: int.parse(newReminder.id.substring(newReminder.id.length - 8)),
      title: title,
      body: content,
      scheduledDate: dateTime,
    );
  }

  void _deleteReminder(String id) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    Provider.of<NotificationService>(context, listen: false).cancelNotification(
      int.parse(id.substring(id.length - 8))
    );
    homeProvider.deleteReminder(id);
  }

  Future<void> _showAddDialog() async {
    String title = '';
    String content = '';
    TimeOfDay selectedTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Yeni Anımsatıcı'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Başlık (örn: Kitap Okuma)'),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'İçerik'),
                  onChanged: (value) => content = value,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Zaman Seç'),
                  trailing: Text('${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setDialogState(() => selectedTime = time);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  final now = DateTime.now();
                  final scheduledDateTime = DateTime(
                    now.year, now.month, now.day,
                    selectedTime.hour, selectedTime.minute,
                  );
                  
                  // If the time has already passed today, schedule for tomorrow
                  var finalDateTime = scheduledDateTime;
                  if (scheduledDateTime.isBefore(now)) {
                    finalDateTime = scheduledDateTime.add(const Duration(days: 1));
                  }
                  
                  _addReminder(title, content, finalDateTime);
                  Navigator.pop(context);
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anımsatıcılarım 🔔'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          final reminders = homeProvider.reminders;
          return reminders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.notifications_none, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('Henüz anımsatıcı eklemedin.', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showAddDialog,
                        child: const Text('İlk Anımsatıcıyı Ekle'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.alarm, color: Colors.white),
                        ),
                        title: Text(reminder.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${reminder.content}\nSaat: ${reminder.dateTime.hour}:${reminder.dateTime.minute.toString().padLeft(2, '0')}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _deleteReminder(reminder.id),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
