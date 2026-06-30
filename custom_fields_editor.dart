import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models.dart';
import '../theme.dart';

/// محرر الحقول المخصصة: يسمح بإضافة حقل نصي أو حقل منطقي (Switch) بأي اسم يختاره المستخدم
class CustomFieldsEditor extends StatefulWidget {
  final List<CustomField> fields;
  final ValueChanged<List<CustomField>> onChanged;

  const CustomFieldsEditor(
      {super.key, required this.fields, required this.onChanged});

  @override
  State<CustomFieldsEditor> createState() => _CustomFieldsEditorState();
}

class _CustomFieldsEditorState extends State<CustomFieldsEditor> {
  final _uuid = const Uuid();

  Future<void> _showAddDialog() async {
    final labelController = TextEditingController();
    CustomFieldType selectedType = CustomFieldType.text;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.card,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('إضافة حقل جديد',
                style: TextStyle(color: AppColors.textPrimary)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: labelController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'اسم الحقل (مثال: مذاكرة الرياضيات)',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.cardLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _typeChoice(
                        label: 'نصي',
                        icon: Icons.short_text,
                        selected: selectedType == CustomFieldType.text,
                        onTap: () => setDialogState(
                            () => selectedType = CustomFieldType.text),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _typeChoice(
                        label: 'اختياري (نعم/لا)',
                        icon: Icons.toggle_on,
                        selected: selectedType == CustomFieldType.boolean,
                        onTap: () => setDialogState(
                            () => selectedType = CustomFieldType.boolean),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
              TextButton(
                onPressed: () {
                  final label = labelController.text.trim();
                  if (label.isEmpty) return;
                  setState(() {
                    widget.fields.add(CustomField(
                      id: _uuid.v4(),
                      label: label,
                      type: selectedType,
                    ));
                  });
                  widget.onChanged(widget.fields);
                  Navigator.pop(ctx);
                },
                child: const Text('إضافة',
                    style: TextStyle(
                        color: AppColors.accent2, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _typeChoice({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent.withOpacity(0.25) : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? AppColors.accent : Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: selected ? AppColors.accent2 : AppColors.textSecondary,
                size: 20),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  void _remove(CustomField f) {
    setState(() => widget.fields.remove(f));
    widget.onChanged(widget.fields);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...widget.fields.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: f.type == CustomFieldType.text
                    ? Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: f.textValue,
                              style:
                                  const TextStyle(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                labelText: f.label,
                                labelStyle: const TextStyle(
                                    color: AppColors.textSecondary),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (val) {
                                f.textValue = val;
                                widget.onChanged(widget.fields);
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textSecondary, size: 18),
                            onPressed: () => _remove(f),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Text(f.label,
                                style: const TextStyle(
                                    color: AppColors.textPrimary)),
                          ),
                          Switch(
                            value: f.boolValue,
                            activeColor: AppColors.accent2,
                            onChanged: (val) {
                              setState(() => f.boolValue = val);
                              widget.onChanged(widget.fields);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textSecondary, size: 18),
                            onPressed: () => _remove(f),
                          ),
                        ],
                      ),
              ),
            )),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add_circle_outline,
                color: AppColors.accent2),
            label: const Text('إضافة حقل مخصص',
                style: TextStyle(
                    color: AppColors.accent2, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
