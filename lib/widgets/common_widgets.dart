import 'package:flutter/material.dart' hide DataRow;
import 'package:bmdxf/theme/app_theme.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const InfoCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: const Color(0xFF00FF41), size: 18),
            const SizedBox(width: 8),
            Text(
              '> $title',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF00FF41),
                fontFamily: 'monospace',
                letterSpacing: 1.2,
              ),
            ),
          ]),
          const Divider(height: 16, color: Color(0xFF00FF41)),
          child,
        ],
      ),
    );
  }
}

class DataRow extends StatelessWidget {
  final String label;
  final String value;

  const DataRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF00AA33),
                fontSize: 13,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            ' : ',
            style: TextStyle(
              color: Color(0xFF00FF41),
              fontFamily: 'monospace',
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF00FF41),
                fontSize: 13,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const PrimaryButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text('[ $label ]'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0D1117),
        foregroundColor: const Color(0xFF00FF41),
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Color(0xFF00FF41), width: 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}