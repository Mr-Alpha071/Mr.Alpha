import 'dart:convert';

/// نموذج عنصر الجدول اليومي (لكل ساعة)
class HourSlot {
  final int hour; // 0-23
  String text;

  HourSlot({required this.hour, this.text = ''});

  Map<String, dynamic> toJson() => {'hour': hour, 'text': text};

  factory HourSlot.fromJson(Map<String, dynamic> json) =>
      HourSlot(hour: json['hour'] as int, text: json['text'] as String? ?? '');

  String get label {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour < 12 ? 'ص' : 'م';
    return '$h:00 $period';
  }
}

/// نموذج عنصر بسيط له نص ومؤشر إنجاز (يستخدم للمواد، المهارات)
class SimpleItem {
  String id;
  String title;
  bool done;

  SimpleItem({required this.id, required this.title, this.done = false});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done};

  factory SimpleItem.fromJson(Map<String, dynamic> json) => SimpleItem(
        id: json['id'] as String,
        title: json['title'] as String,
        done: json['done'] as bool? ?? false,
      );
}

/// نوع الحقل المخصص
enum CustomFieldType { text, boolean }

/// حقل مخصص يضيفه المستخدم (نصي أو منطقي/اختياري)
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'type': type.name,
        'textValue': textValue,
        'boolValue': boolValue,
      };

  factory CustomField.fromJson(Map<String, dynamic> json) => CustomField(
        id: json['id'] as String,
        label: json['label'] as String,
        type: (json['type'] == 'boolean')
            ? CustomFieldType.boolean
            : CustomFieldType.text,
        textValue: json['textValue'] as String? ?? '',
        boolValue: json['boolValue'] as bool? ?? false,
      );
}

/// نموذج اليوم الكامل لتجميع كل البيانات
class DayData {
  String date; // yyyy-MM-dd
  List<HourSlot> schedule;
  List<SimpleItem> subjects; // المواد الدراسية
  List<SimpleItem> skills; // المهارات
  String tomorrowExam; // امتحان غد
  int spanishWordsCount; // عدد الكلمات الاسبانية المحفوظة اليوم
  String accomplishedToday; // ماذا أنجزت اليوم
  List<SimpleItem> tomorrowTasks; // أمور علي فعلها غدا
  List<SimpleItem> missedToday; // أمور فوتها اليوم ولازم تُصلح غدا
  List<CustomField> customFields; // حقول مخصصة يضيفها المستخدم

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
  })  : schedule = schedule ?? List.generate(24, (i) => HourSlot(hour: i)),
        subjects = subjects ?? [],
        skills = skills ?? [],
        tomorrowTasks = tomorrowTasks ?? [],
        missedToday = missedToday ?? [],
        customFields = customFields ?? [];

  Map<String, dynamic> toJson() => {
        'date': date,
        'schedule': schedule.map((e) => e.toJson()).toList(),
        'subjects': subjects.map((e) => e.toJson()).toList(),
        'skills': skills.map((e) => e.toJson()).toList(),
        'tomorrowExam': tomorrowExam,
        'spanishWordsCount': spanishWordsCount,
        'accomplishedToday': accomplishedToday,
        'tomorrowTasks': tomorrowTasks.map((e) => e.toJson()).toList(),
        'missedToday': missedToday.map((e) => e.toJson()).toList(),
        'customFields': customFields.map((e) => e.toJson()).toList(),
      };

  factory DayData.fromJson(Map<String, dynamic> json) => DayData(
        date: json['date'] as String,
        schedule: (json['schedule'] as List<dynamic>?)
                ?.map((e) => HourSlot.fromJson(e as Map<String, dynamic>))
                .toList() ??
            List.generate(24, (i) => HourSlot(hour: i)),
        subjects: (json['subjects'] as List<dynamic>?)
                ?.map((e) => SimpleItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        skills: (json['skills'] as List<dynamic>?)
                ?.map((e) => SimpleItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        tomorrowExam: json['tomorrowExam'] as String? ?? '',
        spanishWordsCount: json['spanishWordsCount'] as int? ?? 0,
        accomplishedToday: json['accomplishedToday'] as String? ?? '',
        tomorrowTasks: (json['tomorrowTasks'] as List<dynamic>?)
                ?.map((e) => SimpleItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        missedToday: (json['missedToday'] as List<dynamic>?)
                ?.map((e) => SimpleItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        customFields: (json['customFields'] as List<dynamic>?)
                ?.map((e) => CustomField.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  static DayData empty(String date) => DayData(date: date);

  String encode() => jsonEncode(toJson());
  static DayData decode(String date, String source) =>
      DayData.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
