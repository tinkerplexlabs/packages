import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

/// Service for managing user profiles across TinkerPlex games
class TinkerPlexProfileService {
  final SupabaseClient _client;

  TinkerPlexProfileService(this._client);

  /// Get the current authenticated user's profile
  Future<UserProfile?> getCurrentProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    return getProfile(userId);
  }

  /// Get a user's profile by ID (for leaderboards, etc.)
  Future<UserProfile?> getProfile(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select('id, display_name, avatar_style, avatar_seed')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;

      return UserProfile.fromJson(response);
    } catch (e) {
      // Log error but don't throw - profile fetching should be resilient
      return null;
    }
  }

  /// Get multiple profiles by IDs (for batch leaderboard loading)
  Future<Map<String, UserProfile>> getProfiles(List<String> userIds) async {
    if (userIds.isEmpty) return {};

    try {
      final response = await _client
          .from('users')
          .select('id, display_name, avatar_style, avatar_seed')
          .inFilter('id', userIds);

      final profiles = <String, UserProfile>{};
      for (final row in response) {
        final profile = UserProfile.fromJson(row);
        profiles[profile.id] = profile;
      }
      return profiles;
    } catch (e) {
      return {};
    }
  }

  /// Update the current user's profile
  Future<bool> updateProfile({
    String? displayName,
    String? avatarStyle,
    String? avatarSeed,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final updates = <String, dynamic>{};
      if (displayName != null) updates['display_name'] = displayName;
      if (avatarStyle != null) updates['avatar_style'] = avatarStyle;
      if (avatarSeed != null) updates['avatar_seed'] = avatarSeed;

      if (updates.isEmpty) return true;

      await _client.from('users').update(updates).eq('id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Generate a random seed for avatar generation
  String generateRandomSeed() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(12, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
