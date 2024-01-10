import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class HomeworkEntry {
  @HiveField(0)
  int id;

  @HiveField(1)
  String subject;

  @HiveField(2)
  String notes;

  @HiveField(3)
  DateTime dueDate;

  @HiveField(4)
  bool done = false;

  @HiveField(5)
  DateTime lastUpdated;

  @HiveField(6)
  DateTime? reminderDateTime;

  @HiveField(7)
  int? scheduledNotificationId;

  HomeworkEntry({
    required this.id,
    required this.subject,
    required this.notes,
    required this.dueDate,
    required this.lastUpdated,
    this.reminderDateTime,
    this.scheduledNotificationId,
    this.done = false,
  }) {
    reminderDateTime ??=
        dueDate.subtract(const Duration(days: 1)).isBefore(DateTime.now())
            ? DateTime.now().add(const Duration(seconds: 15))
            : dueDate
                .subtract(const Duration(days: 1))
                .copyWith(hour: 16, minute: 0);
  }

  HomeworkEntry.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        subject = json['subject'],
        notes = json['notes'],
        dueDate = DateTime.parse(json['dueDate']),
        lastUpdated = DateTime.parse(json['lastUpdated']),
        reminderDateTime = json['remindDate'] != null
            ? DateTime.parse(json['remindDate'])
            : null,
        scheduledNotificationId = json['scheduledNotificationId'],
        done = json['done'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'notes': notes,
        'dueDate': dueDate.toIso8601String(),
        'remindDate': reminderDateTime?.toIso8601String(),
        'lastUpdated': lastUpdated.toIso8601String(),
        'scheduledNotificationId': scheduledNotificationId,
        'done': done,
      };

  static void registerAdapter() {
    Hive.registerAdapter(HomeworkEntryAdapter());
  }
}

class HomeworkEntryAdapter extends TypeAdapter<HomeworkEntry> {
  @override
  HomeworkEntry read(BinaryReader reader) {
    return HomeworkEntry(
      id: reader.read() as int,
      subject: reader.read() as String,
      notes: reader.read() as String,
      dueDate: reader.read() as DateTime,
      done: reader.read() as bool,
      lastUpdated: reader.read() as DateTime,
      reminderDateTime: reader.read() as DateTime?, 
      scheduledNotificationId: reader.read() as int?,
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, HomeworkEntry obj) {
    print("Writing HomeworkEntry");
    print(obj.id);
    writer.write(obj.id);
    writer.write(obj.subject);
    writer.write(obj.notes);
    writer.write(obj.dueDate);
    writer.write(obj.done);
    writer.write(obj.lastUpdated);
    writer.write(obj.reminderDateTime);
    writer.write(obj.scheduledNotificationId);
  }
}
