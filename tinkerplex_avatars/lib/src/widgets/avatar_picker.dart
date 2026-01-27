import 'package:flutter/material.dart';
import 'user_avatar.dart';
import '../config/avatar_styles.dart';

/// Widget for selecting an avatar style from available options
class AvatarPicker extends StatelessWidget {
  /// Currently selected style ID
  final String currentStyle;

  /// Current seed for avatar generation
  final String seed;

  /// Called when user selects a different style
  final ValueChanged<String> onStyleChanged;

  /// Called when user wants to randomize the seed
  final VoidCallback? onRandomizeSeed;

  /// Size of each avatar preview
  final double avatarSize;

  const AvatarPicker({
    super.key,
    required this.currentStyle,
    required this.seed,
    required this.onStyleChanged,
    this.onRandomizeSeed,
    this.avatarSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current avatar with randomize button
        Row(
          children: [
            UserAvatar(
              seed: seed,
              style: currentStyle,
              size: avatarSize * 1.5,
            ),
            const SizedBox(width: 16),
            if (onRandomizeSeed != null)
              FilledButton.tonalIcon(
                onPressed: onRandomizeSeed,
                icon: const Icon(Icons.shuffle),
                label: const Text('Randomize'),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Style selection label
        Text(
          'Choose Style',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),

        // Horizontal scrollable list of styles
        SizedBox(
          height: avatarSize + 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableAvatarStyles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final style = availableAvatarStyles[index];
              final isSelected = style.id == currentStyle;

              return _AvatarStyleOption(
                style: style,
                seed: seed,
                size: avatarSize,
                isSelected: isSelected,
                onTap: () => onStyleChanged(style.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AvatarStyleOption extends StatelessWidget {
  final AvatarStyleInfo style;
  final String seed;
  final double size;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarStyleOption({
    required this.style,
    required this.seed,
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(size / 2 + 4),
            ),
            child: UserAvatar(
              seed: seed,
              style: style.id,
              size: size,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            style.name,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
