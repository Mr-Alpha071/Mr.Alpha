import 'dart:convert';

class HourSlot {
  final int hour;
  String text;

  HourSlot({required this.hour, this.text = ''});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'hour': hour, 'text': text};
  }

  factory HourSlot.fromJson(Map<String, dynamic> json) {
    return HourSlot(
      hour: json['hour'] as int,
      text: json['text'] as String? ?? '',
    );
  }

  String get label {
    final int h = hour % 12 == 0 ? 12 : hour % 12;
    final String period = hour < 12 ? 'ص' : 'م';
    return '$h:00 $period';
  }
}

class SimpleItem {
  String id;
  String title;
  bool done;

  SimpleItem({required this.id, required this.title, this.done = false});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'title': title, 'done': done};
  }

  factory SimpleItem.fromJson(Map<String, dynamic> json) {
    return SimpleItem(
      id: json['id'] as String,
      title: json['title'] as String,
      done: json['done'] as bool? ?? false,
    );
  }
}

enum CustomFieldType { text, boolean }

class CustomField {
  String id;
  String label;
  CustomFieldType type;
  String textValue;
  bool boolValue;

  CustomField({
    required this.id,
    required this.label,
    required this.type,
    this.textValue = '',
    this.boolValue = false,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'type': type.name,
      'textValue': textValue,
      'boolValue': boolValue,
    };
  }

  factory CustomField.fromJson(Map<String, dynamic> json) {
    return CustomField(
      id: json['id'] as String,
      label: json['label'] as String,
      type: (json['type'] == 'boolean')
          ? CustomFieldType.boolean
          : CustomFieldType.text,
      textValue: json['textValue'] as String? ?? '',
      boolValue: json['boolValue'] as bool? ?? false,
    );
  }
}

class DayData {
  String date;
  List<HourSlot> schedule;
  List<SimpleItem> subjects;
  List<SimpleItem> skills;
  String tomorrowExam;
  int spanishWordsCount;
  String accomplishedToday;
  List<SimpleItem> tomorrowTasks;
  List<SimpleItem> missedToday;
  List<CustomField> customFields;

  DayData({
    required this.date,
    List<HourSlot>? schedule,
    List<SimpleItem>? subjects,
    List<SimpleItem>? skills,
    this.tomorrowExam = '',
    this.spanishWordsCount = 0,
    this.accomplishedToday = '',
    List<SimpleItem>? tomorrowTasks,
    List<SimpleItem>? missedToday,
    List<CustomField>? customFields,
  })  : schedule = schedule ?? List<HourSlot>.generate(24, (int i) => HourSlot(hour: i)),
        subjects = subjects ?? <SimpleItem>[],
        skills = skills ?? <SimpleItem>[],
        tomorrowTasks = tomorrowTasks ?? <SimpleItem>[],
        missedToday = missedToday ?? <SimpleItem>[],
        customFields = customFields ?? <CustomField>[];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date,
      'schedule': schedule.map((HourSlot e) => e.toJson()).toList(),
      'subjects': subjects.map((SimpleItem e) => e.toJson()).toList(),
      'skills': skills.map((SimpleItem e) => e.toJson()).toList(),
      'tomorrowExam': tomorrowExam,
      'spanishWordsCount': spanishWordsCount,
      'accomplishedToday': accomplishedToday,
      'tomorrowTasks': tomorrowTasks.map((SimpleItem e) => e.toJson()).toList(),
      'missedToday': missedToday.map((SimpleItem e) => e.toJson()).toList(),
      'customFields': customFields.map((CustomField e) => e.toJson()).toList(),
    };
  }

  factory DayData.fromJson(Map<String, dynamic> json) {
    return DayData(
      date: json['date'] as String,
      schedule: (json['schedule'] as List<dynamic>?)
              ?.map((dynamic e) => HourSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          List<HourSlot>.generate(24, (int i) => HourSlot(hour: i)),
      subjects: (json['subjects'] as List<dynamic>?)
              ?.map((dynamic e) => SimpleItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <SimpleItem>[],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((dynamic e) => SimpleItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <SimpleItem>[],
      tomorrowExam: json['tomorrowExam'] as String? ?? '',
      spanishWordsCount: json['spanishWordsCount'] as int? ?? 0,
      accomplishedToday: json['accomplishedToday'] as String? ?? '',
      tomorrowTasks: (json['tomorrowTasks'] as List<dynamic>?)
              ?.map((dynamic e) => SimpleItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <SimpleItem>[],
      missedToday: (json['missedToday'] as List<dynamic>?)
              ?.map((dynamic e) => SimpleItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <SimpleItem>[],
      customFields: (json['customFields'] as List<dynamic>?)
              ?.map((dynamic e) => CustomField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <CustomField>[],
    );
  }

  static DayData empty(String date) => DayData(date: date);
  String encode() => jsonEncode(toJson());
  static DayData decode(String date, String source) {
    return DayData.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }
}
