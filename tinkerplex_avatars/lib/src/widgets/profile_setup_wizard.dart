import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import 'avatar_picker.dart';
import 'leaderboard_preview.dart';
import 'user_avatar.dart';

/// Card-based profile setup wizard for new and migrating users
class ProfileSetupWizard extends StatefulWidget {
  /// Initial profile to start with
  final UserProfile initialProfile;

  /// Profile service for saving changes
  final TinkerPlexProfileService profileService;

  /// Called after profile is successfully completed
  final VoidCallback onCompleted;

  /// Called when user cancels/skips the wizard
  final VoidCallback? onCancelled;

  const ProfileSetupWizard({
    super.key,
    required this.initialProfile,
    required this.profileService,
    required this.onCompleted,
    this.onCancelled,
  });

  @override
  State<ProfileSetupWizard> createState() => _ProfileSetupWizardState();
}

class _ProfileSetupWizardState extends State<ProfileSetupWizard> {
  late PageController _pageController;
  late TextEditingController _displayNameController;
  late String _selectedStyle;
  late String _selectedSeed;
  int _currentPage = 0;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _displayNameController = TextEditingController(
      text: widget.initialProfile.displayName ?? '',
    );
    _selectedStyle = widget.initialProfile.avatarStyle;
    _selectedSeed = widget.initialProfile.avatarSeed;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  Future<void> _completeSetup() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final displayName = _displayNameController.text.trim();
    final success = await widget.profileService.updateProfile(
      displayName: displayName.isEmpty ? null : displayName,
      avatarStyle: _selectedStyle,
      avatarSeed: _selectedSeed,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      widget.onCompleted();
    } else {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save profile. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildAvatarSelectionCard(),
            _buildDisplayNameCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSelectionCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Choose Your Avatar',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Pick a style and select your favorite',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Avatar picker
              Expanded(
                child: SingleChildScrollView(
                  child: AvatarPicker(
                    currentStyle: _selectedStyle,
                    seed: _selectedSeed,
                    onStyleChanged: (style) {
                      setState(() {
                        _selectedStyle = style;
                      });
                    },
                    onSeedChanged: (seed) {
                      setState(() {
                        _selectedSeed = seed;
                      });
                    },
                    avatarSize: 56,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Navigation buttons
              Row(
                children: [
                  // Skip button (if cancellation is allowed)
                  if (widget.onCancelled != null)
                    TextButton(
                      onPressed: widget.onCancelled,
                      child: const Text('Skip'),
                    ),
                  const Spacer(),
                  // Next button
                  FilledButton(
                    onPressed: _goToNextPage,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayNameCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Scrollable content area (handles keyboard resize)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        'What should we call you?',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This name will appear on leaderboards',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Avatar preview
                      Center(
                        child: UserAvatar(
                          seed: _selectedSeed,
                          style: _selectedStyle,
                          size: 80,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Display name field
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _displayNameController,
                          decoration: const InputDecoration(
                            labelText: 'Display Name',
                            hintText: 'Enter your display name',
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.words,
                          maxLength: 30,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a display name';
                            }
                            return null;
                          },
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Leaderboard preview section
                      Text(
                        'Leaderboard Preview',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      LeaderboardPreview(
                        displayName: _displayNameController.text.trim().isEmpty
                            ? 'Player'
                            : _displayNameController.text.trim(),
                        avatarSeed: _selectedSeed,
                        avatarStyle: _selectedStyle,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Navigation buttons (pinned at bottom)
              Row(
                children: [
                  // Back button
                  TextButton(
                    onPressed: _goToPreviousPage,
                    child: const Text('Back'),
                  ),
                  const Spacer(),
                  // Complete button
                  FilledButton(
                    onPressed: _isSaving ? null : _completeSetup,
                    child: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Complete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
