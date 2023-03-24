import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class HomeworkEntry {
  @HiveField(0)
  String subject;

  @HiveField(1)
  String notes;

  @HiveField(2)
  DateTime dueDate;

  @HiveField(3)
  bool done = false;

  @HiveField(4)
  DateTime lastUpdated;

  HomeworkEntry({
    required this.subject,
    required this.notes,
    required this.dueDate,
    required this.lastUpdated,
    this.done = false,
  });

  HomeworkEntry.fromJson(Map<String, dynamic> json)
      : subject = json['subject'],
        notes = json['notes'],
        dueDate = DateTime.parse(json['dueDate']),
        lastUpdated = DateTime.parse(json['lastUpdated']),
        done = json['done'];

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'notes': notes,
        'dueDate': dueDate.toIso8601String(),
        'lastUpdated': lastUpdated.toIso8601String(),
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
        subject: reader.read(),
        notes: reader.read(),
        dueDate: reader.read(),
        lastUpdated: reader.read(),
        done: reader.read());
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, HomeworkEntry obj) {
    writer.write(obj.subject);
    writer.write(obj.notes);
    writer.write(obj.dueDate);
    writer.write(obj.lastUpdated);
    writer.write(obj.done);
  }
}
