import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models.dart';
import '../theme.dart';

class ItemListEditor extends StatefulWidget {
  final List<SimpleItem> items;
  final String hint;
  final ValueChanged<List<SimpleItem>> onChanged;
  final Color accentColor;

  const ItemListEditor({
    super.key,
    required this.items,
    required this.onChanged,
    this.hint = 'أضف عنصرًا جديدًا...',
    this.accentColor = AppColors.accent,
  });

  @override
  State<ItemListEditor> createState() => _ItemListEditorState();
}

class _ItemListEditorState extends State<ItemListEditor> {
  final TextEditingController _controller = TextEditingController();
  final Uuid _uuid = const Uuid();

  void _add() {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      widget.items.add(SimpleItem(id: _uuid.v4(), title: text));
    });
    widget.onChanged(widget.items);
    _controller.clear();
  }

  void _toggle(SimpleItem item) {
    setState(() => item.done = !item.done);
    widget.onChanged(widget.items);
  }

  void _remove(SimpleItem item) {
    setState(() => widget.items.remove(item));
    widget.onChanged(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: AppColors.textPrimary),
                onSubmitted: (String _) => _add(),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.cardLight,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _add,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        if (widget.items.isNotEmpty) const SizedBox(height: 10),
        ...widget.items.map((SimpleItem item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: item.done,
                    activeColor: widget.accentColor,
                    onChanged: (bool? _) => _toggle(item),
                  ),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: item.done
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        decoration: item.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.textSecondary, size: 18),
                    onPressed: () => _remove(item),
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
