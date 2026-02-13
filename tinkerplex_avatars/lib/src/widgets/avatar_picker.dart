import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'user_avatar.dart';
import '../config/avatar_styles.dart';

/// Widget for selecting an avatar from a grid-based browser with style tabs
class AvatarPicker extends StatefulWidget {
  /// Currently selected style ID
  final String currentStyle;

  /// Current seed for avatar generation
  final String seed;

  /// Called when user selects a different style
  final ValueChanged<String> onStyleChanged;

  /// Called when user selects a different seed
  final ValueChanged<String> onSeedChanged;

  /// Size of each avatar in the grid
  final double avatarSize;

  const AvatarPicker({
    super.key,
    required this.currentStyle,
    required this.seed,
    required this.onStyleChanged,
    required this.onSeedChanged,
    this.avatarSize = 56,
  });

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _StyleTabBar(
          currentStyle: widget.currentStyle,
          onStyleChanged: widget.onStyleChanged,
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _AvatarGridView(
            key: ValueKey(widget.currentStyle),
            currentStyle: widget.currentStyle,
            selectedSeed: widget.seed,
            onSeedChanged: widget.onSeedChanged,
            avatarSize: widget.avatarSize,
          ),
        ),
      ],
    );
  }
}

class _StyleTabBar extends StatelessWidget {
  final String currentStyle;
  final ValueChanged<String> onStyleChanged;

  const _StyleTabBar({
    required this.currentStyle,
    required this.onStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: availableAvatarStyles.map((style) {
            final isSelected = style.id == currentStyle;
            return _StyleTab(
              style: style,
              isSelected: isSelected,
              onTap: () => onStyleChanged(style.id),
            );
          }).toList(),
        );
      },
    );
  }
}

class _StyleTab extends StatelessWidget {
  final AvatarStyleInfo style;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleTab({
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: isSelected ? 1.05 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserAvatar(
                seed: avatarSeeds[0],
                style: style.id,
                size: 32,
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
        ),
      ),
    );
  }
}

class _AvatarGridView extends StatelessWidget {
  final String currentStyle;
  final String selectedSeed;
  final ValueChanged<String> onSeedChanged;
  final double avatarSize;

  const _AvatarGridView({
    super.key,
    required this.currentStyle,
    required this.selectedSeed,
    required this.onSeedChanged,
    required this.avatarSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: avatarSeeds.map((seed) {
          return _AvatarGridItem(
            seed: seed,
            styleId: currentStyle,
            isSelected: seed == selectedSeed,
            onTap: () {
              if (seed != selectedSeed) {
                onSeedChanged(seed);
              }
            },
            size: avatarSize,
          );
        }).toList(),
      ),
    );
  }
}

class _AvatarGridItem extends StatelessWidget {
  final String seed;
  final String styleId;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;

  const _AvatarGridItem({
    required this.seed,
    required this.styleId,
    required this.isSelected,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 3 : 1,
          ),
        ),
        child: UserAvatar(
          seed: seed,
          style: styleId,
          size: size,
          placeholder: _ShimmerCircle(size: size),
        ),
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  final double size;

  const _ShimmerCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
