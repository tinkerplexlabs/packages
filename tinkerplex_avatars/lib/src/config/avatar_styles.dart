/// Information about an avatar style
class AvatarStyleInfo {
  /// Style ID used with DiceBear API
  final String id;

  /// Human-readable name
  final String name;

  /// Brief description of the style
  final String description;

  const AvatarStyleInfo({
    required this.id,
    required this.name,
    required this.description,
  });
}

/// Available CC0-licensed avatar styles from DiceBear
/// These styles are completely free for commercial use with no attribution required
const List<AvatarStyleInfo> availableAvatarStyles = [
  AvatarStyleInfo(
    id: 'pixel-art',
    name: 'Pixel Art',
    description: 'Retro pixel characters',
  ),
  AvatarStyleInfo(
    id: 'lorelei',
    name: 'Lorelei',
    description: 'Cute illustrated faces',
  ),
  AvatarStyleInfo(
    id: 'thumbs',
    name: 'Thumbs',
    description: 'Simple thumb characters',
  ),
  AvatarStyleInfo(
    id: 'avataaars',
    name: 'Avataaars',
    description: 'Cartoon people',
  ),
  AvatarStyleInfo(
    id: 'bottts',
    name: 'Bottts',
    description: 'Friendly robots',
  ),
  AvatarStyleInfo(
    id: 'initials',
    name: 'Initials',
    description: 'Letters on colored background',
  ),
  AvatarStyleInfo(
    id: 'shapes',
    name: 'Shapes',
    description: 'Abstract geometric',
  ),
];

/// Default avatar style
const String defaultAvatarStyle = 'pixel-art';

/// Get avatar style info by ID
AvatarStyleInfo? getAvatarStyleInfo(String styleId) {
  try {
    return availableAvatarStyles.firstWhere((s) => s.id == styleId);
  } catch (_) {
    return null;
  }
}
