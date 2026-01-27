import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/user_profile.dart';
import '../config/avatar_styles.dart';

/// Widget that displays a user's DiceBear avatar
class UserAvatar extends StatelessWidget {
  /// Seed for generating the avatar
  final String seed;

  /// DiceBear style ID
  final String style;

  /// Size of the avatar (width and height)
  final double size;

  /// Optional placeholder widget while loading
  final Widget? placeholder;

  /// Optional border radius (defaults to circular)
  final BorderRadius? borderRadius;

  /// Create an avatar with explicit values
  const UserAvatar({
    super.key,
    required this.seed,
    this.style = defaultAvatarStyle,
    this.size = 48,
    this.placeholder,
    this.borderRadius,
  });

  /// Create an avatar from a UserProfile
  factory UserAvatar.fromProfile(
    UserProfile profile, {
    Key? key,
    double size = 48,
    Widget? placeholder,
    BorderRadius? borderRadius,
  }) {
    return UserAvatar(
      key: key,
      seed: profile.avatarSeed,
      style: profile.avatarStyle,
      size: size,
      placeholder: placeholder,
      borderRadius: borderRadius,
    );
  }

  /// Get the DiceBear URL for this avatar
  String get avatarUrl =>
      'https://api.dicebear.com/9.x/$style/svg?seed=$seed&size=${size.toInt()}';

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(size / 2);

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: size,
        height: size,
        child: SvgPicture.network(
          avatarUrl,
          width: size,
          height: size,
          placeholderBuilder: (context) =>
              placeholder ?? _buildPlaceholder(context),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: SizedBox(
          width: size * 0.4,
          height: size * 0.4,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
