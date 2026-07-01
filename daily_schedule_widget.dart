import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

class DailyScheduleWidget extends StatefulWidget {
  final List<HourSlot> schedule;
  final ValueChanged<List<HourSlot>> onChanged;

  const DailyScheduleWidget({
    super.key,
    required this.schedule,
    required this.onChanged,
  });

  @override
  State<DailyScheduleWidget> createState() => _DailyScheduleWidgetState();
}

class _DailyScheduleWidgetState extends State<DailyScheduleWidget> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: <Widget>[
                const Spacer(),
                Text(
                  _expanded ? 'طي الجدول' : 'عرض الجدول كاملاً',
                  style: const TextStyle(
                      color: AppColors.accent2, fontWeight: FontWeight.w600),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.accent2,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          ...widget.schedule.map((HourSlot slot) {
            final bool isNow = slot.hour == now.hour;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: isNow
                      ? AppColors.accent.withOpacity(0.18)
                      : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(14),
                  border: isNow
                      ? Border.all(color: AppColors.accent, width: 1.2)
                      : null,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 64,
                      child: Text(
                        slot.label,
                        style: TextStyle(
                          color: isNow
                              ? AppColors.accent2
                              : AppColors.textSecondary,
                          fontWeight: isNow
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 22,
                      color: Colors.white12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: slot.text,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'ماذا ستفعل في هذه الساعة؟',
                          hintStyle:
                              TextStyle(color: AppColors.textSecondary),
                        ),
                        onChanged: (String val) {
                          slot.text = val;
                          widget.onChanged(widget.schedule);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
