import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../storage_service.dart';
import '../theme.dart';
import '../widgets/daily_schedule_widget.dart';
import '../widgets/item_list_editor.dart';
import '../widgets/custom_fields_editor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  late String _todayKey;
  DayData? _day;
  Timer? _debounce;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _load();
  }

  Future<void> _load() async {
    final data = await _storage.loadDay(_todayKey);
    setState(() => _day = data);
  }

  void _persist() {
    if (_day == null) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await _storage.saveDay(_day!);
      if (mounted) {
        setState(() => _saved = true);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _saved = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_day == null) {
      return Container(
        decoration: BoxDecoration(gradient: bgGradient()),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    final day = _day!;
    final dateLabel =
        DateFormat('EEEE، d MMMM yyyy', 'ar').format(DateTime.now());

    return Container(
      decoration: BoxDecoration(gradient: bgGradient()),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'منظّم يومي',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dateLabel,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _saved ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Row(
                        children: const [
                          Icon(Icons.cloud_done_rounded,
                              color: AppColors.success, size: 18),
                          SizedBox(width: 4),
                          Text('تم الحفظ',
                              style: TextStyle(
                                  color: AppColors.success, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // الجدول اليومي
                  Card3D(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionHeader(
                            title: 'الجدول اليومي (24 ساعة)',
                            icon: Icons.schedule_rounded),
                        const SizedBox(height: 12),
                        DailyScheduleWidget(
                          schedule: day.schedule,
                          onChanged: (_) => _persist(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // المواد الدراسية
                  Card3D(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionHeader(
                            title: 'المواد الدراسية',
                            icon: Icons.menu_book_rounded),
                        const SizedBox(height: 12),
                        ItemListEditor(
                          items: day.subjects,
                          hint: 'أضف مادة دراسية...',
                          accentColor: AppColors.accent,
                          onChanged: (_) => _persist(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // المهارات
                  Card3D(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionHeader(
                            title: 'المهارات', icon: Icons.bolt_rounded),
                        const SizedBox(height: 12),
                        ItemListEditor(
                          items: day.skills,
                          hint: 'أضف مهارة تريد تطويرها...',
                          accentColor: AppColors.accent2,
                          onChanged: (_) => _persist(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // امتحان الغد
                  Card3D(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionHeader(
                            title: 'امتحان الغد',
                            icon: Icons.assignment_rounded),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: day.tomorrowExam,
                          style: const TextStyle(color: AppColors.textPrimary),
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'هل لديك امتحان غدًا؟ في أي مادة؟',
                            hintStyle:
                                const TextStyle(color: AppColors.textSecondary),
                            filled: true,
                            fillColor: AppColors.cardLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (val) {
                            day.tomorrowExam = val;
                            _persist();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // اللغة الاسبانية
                  Card3D(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionHeader(
                            title: 'اللغة الإسبانية',
                            icon: Icons.translate_rounded),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text('عدد الكلمات المحفوظة اليوم:',
                                style:
                                    TextStyle(color: AppColors.textSecondary)),
                            const Spacer(),
                            _StepperCounter(
                              value: day.spanishWordsCount,
                              onChanged: (val) {
                                setState(() => day.spanishWordsCount = val);
                                _persist();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ماذا أنجزت اليوم
                  Card3D(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionHeader(
                            title: 'ماذا أنجزت اليوم؟',
                            icon: Icons.emoji_events_rounded),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: day.accomplishedToday,
                          style: const TextStyle(color: AppColors.textPrimary),
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'اكتب أهم إنجازاتك اليوم...',
                            hintStyle:
                                const TextStyle(color: AppColors.textSecondary),
                            filled: true,
                            fillColor: AppColors.cardLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (val) {
                            day.accomplishedToday = val;
                            _persist();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // أمور علي فعلها غدا
                  Card3D(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionHeader(
                            title: 'أمور علي فعلها غدًا',
                            icon: Icons.checklist_rounded),
                        const SizedBox(height: 12),
                        ItemListEditor(
                          items: day.tomorrowTasks,
                          hint: 'أضف مهمة لغدًا...',
                          accentColor: AppColors.success,
                          onChanged: (_) => _persist(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // أمور فوتها اليوم
                  Card3D(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionHeader(
                            title: 'أمور فوّتها اليوم (لازم تُصلح غدًا)',
                            icon: Icons.report_problem_rounded),
                        const SizedBox(height: 12),
                        ItemListEditor(
                          items: day.missedToday,
                          hint: 'ما الذي فوتّه اليوم؟',
                          accentColor: AppColors.danger,
                          onChanged: (_) => _persist(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // الحقول المخصصة
                  Card3D(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionHeader(
                            title: 'حقول مخصصة',
                            icon: Icons.dashboard_customize_rounded),
                        const SizedBox(height: 12),
                        CustomFieldsEditor(
                          fields: day.customFields,
                          onChanged: (_) => _persist(),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperCounter extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _StepperCounter({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: AppColors.danger, size: 18),
            onPressed: value > 0 ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.success, size: 18),
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}
