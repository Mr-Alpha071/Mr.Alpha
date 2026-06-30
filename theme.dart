import 'package:flutter/material.dart';

/// ألوان وتدرجات التطبيق العامة
class AppColors {
  static const bg = Color(0xFF0F1024);
  static const bgGradientEnd = Color(0xFF1B1E3F);
  static const card = Color(0xFF1E2147);
  static const cardLight = Color(0xFF272B58);
  static const accent = Color(0xFF7C5CFF);
  static const accent2 = Color(0xFF22D3EE);
  static const success = Color(0xFF34D399);
  static const warning = Color(0xFFFBBF24);
  static const danger = Color(0xFFF87171);
  static const textPrimary = Color(0xFFF5F6FF);
  static const textSecondary = Color(0xFFA0A3C4);
}

LinearGradient bgGradient() => const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.bg, AppColors.bgGradientEnd],
    );

LinearGradient accentGradient() => const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.accent, AppColors.accent2],
    );

/// بطاقة بتأثير ثلاثي الأبعاد (ظلال متعددة الطبقات + حواف لامعة)
class Card3D extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double radius;

  const Card3D({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.card,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.accent.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.03),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// عنوان قسم مع أيقونة وتدرج لوني
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;

  const SectionHeader(
      {super.key, required this.title, required this.icon, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            gradient: accentGradient(),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.45),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// زر بتأثير ثلاثي الأبعاد بتدرج لوني
class Button3D extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool small;

  const Button3D({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: small ? 14 : 18, vertical: small ? 9 : 13),
          decoration: BoxDecoration(
            gradient: accentGradient(),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: small ? 16 : 18),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: small ? 13 : 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
