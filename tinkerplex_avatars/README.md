# TinkerPlex Avatars

Shared avatar and profile system for TinkerPlex Labs games. Provides consistent user identity across all games with DiceBear-powered avatars.

## Features

- **Shared Identity**: Same avatar and display name across all TinkerPlex games
- **DiceBear Integration**: CC0-licensed avatar styles (free for commercial use)
- **Easy Integration**: Add to any Flutter app in minutes
- **Customizable**: Users can choose styles and randomize their avatar

## Quick Start (5 minutes)

### Step 1: Add Dependency

```yaml
# pubspec.yaml
dependencies:
  tinkerplex_avatars:
    path: ../packages/tinkerplex_avatars
```

Run `flutter pub get`.

### Step 2: Initialize Profile Service

```dart
// main.dart - after Supabase initialization
import 'package:tinkerplex_avatars/tinkerplex_avatars.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_ANON_KEY',
  );

  // Create profile service using existing Supabase client
  final profileService = TinkerPlexProfileService(
    Supabase.instance.client,
  );

  // Register with GetIt or your DI container
  getIt.registerSingleton(profileService);

  runApp(MyApp());
}
```

### Step 3: Display Avatars in Leaderboard

```dart
// In your leaderboard widget
import 'package:tinkerplex_avatars/tinkerplex_avatars.dart';

// For each leaderboard entry:
UserAvatar(
  seed: entry.avatarSeed,
  style: entry.avatarStyle,
  size: 40,
)
```

### Step 4: Add Profile Editing to Settings

```dart
// In settings screen
import 'package:tinkerplex_avatars/tinkerplex_avatars.dart';

// Get current profile
final profileService = getIt<TinkerPlexProfileService>();
final profile = await profileService.getCurrentProfile();

// Add profile edit tile
ListTile(
  leading: profile != null
    ? UserAvatar.fromProfile(profile)
    : const Icon(Icons.person),
  title: Text(profile?.displayNameOrDefault ?? 'Player'),
  subtitle: const Text('Edit Profile'),
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProfileEditor(
        initialProfile: profile!,
        profileService: profileService,
        onSaved: () => Navigator.pop(context),
      ),
    ),
  ),
)
```

## API Reference

### UserAvatar Widget

Display a DiceBear avatar.

```dart
// Basic usage
UserAvatar(
  seed: 'unique-seed-string',
  style: 'pixel-art',  // optional, defaults to pixel-art
  size: 48,            // optional, defaults to 48
)

// From a UserProfile
UserAvatar.fromProfile(profile, size: 48)
```

### AvatarPicker Widget

Let users choose avatar style and randomize.

```dart
AvatarPicker(
  currentStyle: 'pixel-art',
  seed: 'current-seed',
  onStyleChanged: (newStyle) {
    // User selected a different style
  },
  onRandomizeSeed: () {
    // User wants a new random avatar
  },
  avatarSize: 64,  // optional
)
```

### ProfileEditor Widget

Full profile editing screen.

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ProfileEditor(
      initialProfile: currentProfile,
      profileService: profileService,
      title: 'Edit Profile',  // optional
      onSaved: () => Navigator.pop(context),
      onCancel: () => Navigator.pop(context),  // optional
    ),
  ),
)
```

### TinkerPlexProfileService

Service for profile CRUD operations.

```dart
final service = TinkerPlexProfileService(supabaseClient);

// Get current user's profile
final profile = await service.getCurrentProfile();

// Get any user's profile (for leaderboards)
final otherProfile = await service.getProfile(userId);

// Get multiple profiles at once
final profiles = await service.getProfiles([userId1, userId2]);

// Update current user's profile
await service.updateProfile(
  displayName: 'NewName',
  avatarStyle: 'lorelei',
  avatarSeed: 'new-seed',
);

// Generate a random seed
final newSeed = service.generateRandomSeed();
```

### UserProfile Model

```dart
class UserProfile {
  final String id;
  final String? displayName;
  final String avatarStyle;
  final String avatarSeed;

  String get displayNameOrDefault; // Returns 'Player' if no name set
}
```

## Available Avatar Styles

All styles are CC0-licensed (free for commercial use, no attribution required):

| Style ID | Name | Description |
|----------|------|-------------|
| `pixel-art` | Pixel Art | Retro pixel characters |
| `lorelei` | Lorelei | Cute illustrated faces |
| `thumbs` | Thumbs | Simple thumb characters |
| `avataaars` | Avataaars | Cartoon people |
| `bottts` | Bottts | Friendly robots |
| `initials` | Initials | Letters on colored background |
| `shapes` | Shapes | Abstract geometric |

## Database Requirements

The package expects these columns on the `users` table:

```sql
display_name TEXT,
avatar_style TEXT DEFAULT 'pixel-art',
avatar_seed TEXT
```

Run this migration if columns don't exist:

```sql
ALTER TABLE users
ADD COLUMN IF NOT EXISTS display_name TEXT,
ADD COLUMN IF NOT EXISTS avatar_style TEXT DEFAULT 'pixel-art',
ADD COLUMN IF NOT EXISTS avatar_seed TEXT;

UPDATE users SET avatar_seed = id::text WHERE avatar_seed IS NULL;
```

## Leaderboard Integration

Update your leaderboard query to include avatar fields:

```sql
SELECT
  u.id,
  COALESCE(u.display_name, 'Player') as display_name,
  COALESCE(u.avatar_style, 'pixel-art') as avatar_style,
  COALESCE(u.avatar_seed, u.id::text) as avatar_seed,
  -- ... other leaderboard fields
FROM leaderboard_stats ls
JOIN users u ON ls.user_id = u.id
```

Update your `LeaderboardEntry` model to include avatar fields:

```dart
class LeaderboardEntry {
  final String userId;
  final String displayName;
  final String avatarStyle;
  final String avatarSeed;
  // ... other fields

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'],
      displayName: json['display_name'] ?? 'Player',
      avatarStyle: json['avatar_style'] ?? 'pixel-art',
      avatarSeed: json['avatar_seed'] ?? json['user_id'],
      // ... other fields
    );
  }
}
```

## Full Integration Checklist

- [ ] Add `tinkerplex_avatars` dependency to `pubspec.yaml`
- [ ] Run `flutter pub get`
- [ ] Initialize `TinkerPlexProfileService` after Supabase
- [ ] Register service with dependency injection (GetIt, etc.)
- [ ] Update `LeaderboardEntry` model to include `avatarStyle`, `avatarSeed`, `displayName`
- [ ] Update leaderboard query/view to include avatar columns
- [ ] Replace initials/placeholder in leaderboard with `UserAvatar` widget
- [ ] Add profile edit option to Settings screen
- [ ] (Optional) Show avatar in app bar or user info area

## Troubleshooting

### Avatar not loading

1. Check network connectivity
2. Verify the seed is not empty
3. Check browser console for CORS errors (web only)
4. Ensure `flutter_svg` is properly configured

### Profile not saving

1. Verify user is authenticated
2. Check Supabase RLS policies allow update
3. Check Supabase logs for errors

### Avatar looks different than expected

DiceBear generates avatars deterministically from the seed. If you change the seed, the avatar changes. The same seed always produces the same avatar.

## License

This package is proprietary to TinkerPlex Labs. The DiceBear avatar styles used are CC0-licensed (public domain).
