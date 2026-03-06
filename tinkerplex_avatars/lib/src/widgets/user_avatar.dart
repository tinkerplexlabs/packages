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

  /// Optional base path for bundled SVG assets.
  /// When provided and the seed is a preset seed, loads from
  /// `$assetBasePath/$style/$seed.svg` instead of the network.
  final String? assetBasePath;

  /// Create an avatar with explicit values
  const UserAvatar({
    super.key,
    required this.seed,
    this.style = defaultAvatarStyle,
    this.size = 48,
    this.placeholder,
    this.borderRadius,
    this.assetBasePath,
  });

  /// Create an avatar from a UserProfile
  factory UserAvatar.fromProfile(
    UserProfile profile, {
    Key? key,
    double size = 48,
    Widget? placeholder,
    BorderRadius? borderRadius,
    String? assetBasePath,
  }) {
    return UserAvatar(
      key: key,
      seed: profile.avatarSeed,
      style: profile.avatarStyle,
      size: size,
      placeholder: placeholder,
      borderRadius: borderRadius,
      assetBasePath: assetBasePath,
    );
  }

  /// Whether this avatar can be loaded from bundled assets
  bool get _canLoadFromAsset =>
      assetBasePath != null && avatarSeeds.contains(seed);

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
        child: _canLoadFromAsset
            ? SvgPicture.asset(
                '$assetBasePath/$style/$seed.svg',
                width: size,
                height: size,
                fit: BoxFit.cover,
              )
            : SvgPicture.network(
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
