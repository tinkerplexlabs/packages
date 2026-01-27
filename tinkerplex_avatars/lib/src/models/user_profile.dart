/// User profile model for TinkerPlex games
class UserProfile {
  /// User ID (from Supabase auth)
  final String id;

  /// User-chosen display name (shown on leaderboards)
  final String? displayName;

  /// DiceBear avatar style (e.g., 'pixel-art', 'lorelei')
  final String avatarStyle;

  /// Seed for generating unique avatar
  final String avatarSeed;

  const UserProfile({
    required this.id,
    this.displayName,
    this.avatarStyle = 'pixel-art',
    required this.avatarSeed,
  });

  /// Returns display name or 'Player' as default
  String get displayNameOrDefault => displayName ?? 'Player';

  /// Create from Supabase JSON response
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return UserProfile(
      id: id,
      displayName: json['display_name'] as String?,
      avatarStyle: (json['avatar_style'] as String?) ?? 'pixel-art',
      avatarSeed: (json['avatar_seed'] as String?) ?? id,
    );
  }

  /// Convert to JSON for Supabase updates
  Map<String, dynamic> toJson() => {
        'display_name': displayName,
        'avatar_style': avatarStyle,
        'avatar_seed': avatarSeed,
      };

  /// Create a copy with modified fields
  UserProfile copyWith({
    String? id,
    String? displayName,
    String? avatarStyle,
    String? avatarSeed,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarStyle: avatarStyle ?? this.avatarStyle,
      avatarSeed: avatarSeed ?? this.avatarSeed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          avatarStyle == other.avatarStyle &&
          avatarSeed == other.avatarSeed;

  @override
  int get hashCode =>
      id.hashCode ^
      displayName.hashCode ^
      avatarStyle.hashCode ^
      avatarSeed.hashCode;
}
