import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models.dart';
import '../theme.dart';

class CustomFieldsEditor extends StatefulWidget {
  final List<CustomField> fields;
  final ValueChanged<List<CustomField>> onChanged;

  const CustomFieldsEditor({
    super.key,
    required this.fields,
    required this.onChanged,
  });

  @override
  State<CustomFieldsEditor> createState() => _CustomFieldsEditorState();
}

class _CustomFieldsEditorState extends State<CustomFieldsEditor> {
  final Uuid _uuid = const Uuid();

  Future<void> _showAddDialog() async {
    final TextEditingController labelController = TextEditingController();
    CustomFieldType selectedType = CustomFieldType.text;

    await showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.card,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text('إضافة حقل جديد',
                  style: TextStyle(color: AppColors.textPrimary)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: labelController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'اسم الحقل',
                      hintStyle:
                          const TextStyle(color: AppColors.textSecondary),
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
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setDialogState(
                              () => selectedType = CustomFieldType.text),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedType == CustomFieldType.text
                                  ? AppColors.accent.withOpacity(0.25)
                                  : AppColors.cardLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedType == CustomFieldType.text
                                    ? AppColors.accent
                                    : Colors.transparent,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.short_text,
                                    color: selectedType == CustomFieldType.text
                                        ? AppColors.accent2
                                        : AppColors.textSecondary,
                                    size: 20),
                                const SizedBox(height: 4),
                                Text('نصي',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: selectedType == CustomFieldType.text
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setDialogState(
                              () => selectedType = CustomFieldType.boolean),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedType == CustomFieldType.boolean
                                  ? AppColors.accent.withOpacity(0.25)
                                  : AppColors.cardLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedType == CustomFieldType.boolean
                                    ? AppColors.accent
                                    : Colors.transparent,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.toggle_on,
                                    color: selectedType == CustomFieldType.boolean
                                        ? AppColors.accent2
                                        : AppColors.textSecondary,
                                    size: 20),
                                const SizedBox(height: 4),
                                Text('نعم / لا',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: selectedType == CustomFieldType.boolean
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('إلغاء',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
                TextButton(
                  onPressed: () {
                    final String label = labelController.text.trim();
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
                          color: AppColors.accent2,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ...widget.fields.map((CustomField f) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: f.type == CustomFieldType.text
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            initialValue: f.textValue,
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              labelText: f.label,
                              labelStyle: const TextStyle(
                                  color: AppColors.textSecondary),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onChanged: (String val) {
                              f.textValue = val;
                              widget.onChanged(widget.fields);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: AppColors.textSecondary, size: 18),
                          onPressed: () {
                            setState(() => widget.fields.remove(f));
                            widget.onChanged(widget.fields);
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(f.label,
                              style: const TextStyle(
                                  color: AppColors.textPrimary)),
                        ),
                        Switch(
                          value: f.boolValue,
                          activeColor: AppColors.accent2,
                          onChanged: (bool val) {
                            setState(() => f.boolValue = val);
                            widget.onChanged(widget.fields);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: AppColors.textSecondary, size: 18),
                          onPressed: () {
                            setState(() => widget.fields.remove(f));
                            widget.onChanged(widget.fields);
                          },
                        ),
                      ],
                    ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add_circle_outline, color: AppColors.accent2),
            label: const Text('إضافة حقل مخصص',
                style: TextStyle(
                    color: AppColors.accent2, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
