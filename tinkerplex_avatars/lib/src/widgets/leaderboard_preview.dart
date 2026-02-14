import 'package:flutter/material.dart';
import 'user_avatar.dart';

/// Preview of how the user will appear on leaderboards
class LeaderboardPreview extends StatelessWidget {
  final String displayName;
  final String avatarSeed;
  final String avatarStyle;

  const LeaderboardPreview({
    super.key,
    required this.displayName,
    required this.avatarSeed,
    required this.avatarStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '1',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar
          UserAvatar(
            seed: avatarSeed,
            style: avatarStyle,
            size: 40,
          ),
          const SizedBox(width: 12),

          // Name
          Expanded(
            child: Text(
              displayName,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Win rate (sample)
          Text(
            '85%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}
