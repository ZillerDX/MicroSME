import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class EmojiPicker extends StatelessWidget {
  final String? selectedEmoji;
  final Function(String) onEmojiSelected;

  const EmojiPicker({
    super.key,
    this.selectedEmoji,
    required this.onEmojiSelected,
  });

  static const List<String> emojis = [
    '☕', '🍵', '🍰', '🍪', '🥪', '💧',
    '🧃', '🥤', '🍞', '🍩', '🍕', '🍔',
    '🌭', '🍟', '🥗', '🍝', '🍜', '🍲',
    '🥘', '🍛', '🍱', '🍙', '🍚', '🍣',
    '🥟', '🍤', '🍦', '🧁', '🎂', '🍮',
    '🍯', '🥛', '🍷', '🍺', '🥂', '🍾',
    '📦', '🛒', '💼', '👕', '👔', '👗',
    '👠', '👟', '🎒', '💄', '💍', '⌚',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Emoji',
          style: TextStyle(
            fontSize: AppFontSizes.md,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 200,
            maxWidth: double.infinity,
          ),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.sm),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
            ),
            itemCount: emojis.length,
            itemBuilder: (context, index) {
              final emoji = emojis[index];
              final isSelected = emoji == selectedEmoji;

              return InkWell(
                onTap: () => onEmojiSelected(emoji),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            },
            ),
          ),
        ),
      ],
    );
  }
}
