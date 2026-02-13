/// Information about an avatar style
class AvatarStyleInfo {
  /// Style ID used with DiceBear API
  final String id;

  /// Human-readable name
  final String name;

  /// Brief description of the style
  final String description;

  /// License type (e.g., 'CC0' or 'CC BY 4.0')
  final String? license;

  /// Creator name for attribution
  final String? creator;

  const AvatarStyleInfo({
    required this.id,
    required this.name,
    required this.description,
    this.license,
    this.creator,
  });
}

/// Available avatar styles from DiceBear
/// Mix of CC0 (public domain) and CC BY 4.0 (attribution required) licenses
const List<AvatarStyleInfo> availableAvatarStyles = [
  AvatarStyleInfo(
    id: 'adventurer',
    name: 'Adventurer',
    description: 'Illustrated adventurer faces',
    license: 'CC BY 4.0',
    creator: 'Lisa Wischofsky',
  ),
  AvatarStyleInfo(
    id: 'fun-emoji',
    name: 'Fun Emoji',
    description: 'Playful emoji characters',
    license: 'CC BY 4.0',
    creator: 'Davis Uche',
  ),
  AvatarStyleInfo(
    id: 'big-ears',
    name: 'Big Ears',
    description: 'Characters with big ears',
    license: 'CC BY 4.0',
    creator: 'The Visual Team',
  ),
  AvatarStyleInfo(
    id: 'lorelei',
    name: 'Lorelei',
    description: 'Minimalist line-art faces',
    license: 'CC0',
    creator: 'Lisa Wischofsky',
  ),
  AvatarStyleInfo(
    id: 'pixel-art',
    name: 'Pixel Art',
    description: 'Retro pixel characters',
    license: 'CC0',
  ),
  AvatarStyleInfo(
    id: 'bottts',
    name: 'Bottts',
    description: 'Friendly robots',
  ),
  AvatarStyleInfo(
    id: 'thumbs',
    name: 'Thumbs',
    description: 'Simple thumb characters',
    license: 'CC0',
  ),
];

/// Fixed avatar seeds for grid-based picker
/// Using predefined seeds ensures consistent avatars across sessions and enables caching
const List<String> avatarSeeds = [
  'avatar-01', 'avatar-02', 'avatar-03', 'avatar-04', 'avatar-05',
  'avatar-06', 'avatar-07', 'avatar-08', 'avatar-09', 'avatar-10',
  'avatar-11', 'avatar-12', 'avatar-13', 'avatar-14', 'avatar-15',
  'avatar-16', 'avatar-17', 'avatar-18', 'avatar-19', 'avatar-20',
];

/// Default avatar style
const String defaultAvatarStyle = 'adventurer';

/// Get avatar style info by ID
AvatarStyleInfo? getAvatarStyleInfo(String styleId) {
  try {
    return availableAvatarStyles.firstWhere((s) => s.id == styleId);
  } catch (_) {
    return null;
  }
}
