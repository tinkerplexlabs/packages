import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import 'avatar_picker.dart';
import 'leaderboard_preview.dart';

/// Full-screen or modal widget for editing user profile
class ProfileEditor extends StatefulWidget {
  /// Initial profile to edit
  final UserProfile initialProfile;

  /// Profile service for saving changes
  final TinkerPlexProfileService profileService;

  /// Called after profile is successfully saved
  final VoidCallback? onSaved;

  /// Called when user cancels editing
  final VoidCallback? onCancel;

  /// Title shown in the app bar
  final String title;

  const ProfileEditor({
    super.key,
    required this.initialProfile,
    required this.profileService,
    this.onSaved,
    this.onCancel,
    this.title = 'Edit Profile',
  });

  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  late TextEditingController _displayNameController;
  late String _avatarStyle;
  late String _avatarSeed;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.initialProfile.displayName ?? '',
    );
    _avatarStyle = widget.initialProfile.avatarStyle;
    _avatarSeed = widget.initialProfile.avatarSeed;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    return _displayNameController.text != (widget.initialProfile.displayName ?? '') ||
        _avatarStyle != widget.initialProfile.avatarStyle ||
        _avatarSeed != widget.initialProfile.avatarSeed;
  }

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final displayName = _displayNameController.text.trim();
    final success = await widget.profileService.updateProfile(
      displayName: displayName.isEmpty ? null : displayName,
      avatarStyle: _avatarStyle,
      avatarSeed: _avatarSeed,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      widget.onSaved?.call();
    } else {
      setState(() {
        _errorMessage = 'Failed to save profile. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _hasChanges && !_isSaving ? _save : null,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
          // Padding to avoid overlap with bug report button overlay
          const SizedBox(width: 48),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error message
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Avatar picker
            Center(
              child: AvatarPicker(
                currentStyle: _avatarStyle,
                seed: _avatarSeed,
                onStyleChanged: (style) {
                  setState(() {
                    _avatarStyle = style;
                  });
                },
                onSeedChanged: (seed) {
                  setState(() {
                    _avatarSeed = seed;
                  });
                },
                avatarSize: 56,
              ),
            ),
            const SizedBox(height: 32),

            // Display name field
            Text(
              'Display Name',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                hintText: 'Enter your display name',
                helperText: 'This name will appear on leaderboards',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              maxLength: 30,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Preview section
            Text(
              'Preview',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            LeaderboardPreview(
              displayName: _displayNameController.text.trim().isEmpty
                  ? 'Player'
                  : _displayNameController.text.trim(),
              avatarSeed: _avatarSeed,
              avatarStyle: _avatarStyle,
            ),
          ],
        ),
      ),
    );
  }
}
