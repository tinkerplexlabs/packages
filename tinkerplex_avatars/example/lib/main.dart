import 'package:flutter/material.dart';
import 'package:tinkerplex_avatars/tinkerplex_avatars.dart';

/// Example usage of the TinkerPlex Avatars package
void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TinkerPlex Avatars Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatefulWidget {
  const ExampleHome({super.key});

  @override
  State<ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> {
  String _currentStyle = 'pixel-art';
  String _currentSeed = 'example-user-123';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic avatar display
            Text(
              'Basic Avatar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                UserAvatar(
                  seed: _currentSeed,
                  style: _currentStyle,
                  size: 48,
                ),
                const SizedBox(width: 16),
                UserAvatar(
                  seed: _currentSeed,
                  style: _currentStyle,
                  size: 64,
                ),
                const SizedBox(width: 16),
                UserAvatar(
                  seed: _currentSeed,
                  style: _currentStyle,
                  size: 96,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Avatar picker
            Text(
              'Avatar Picker',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AvatarPicker(
              currentStyle: _currentStyle,
              seed: _currentSeed,
              onStyleChanged: (style) {
                setState(() {
                  _currentStyle = style;
                });
              },
              onRandomizeSeed: () {
                setState(() {
                  _currentSeed = DateTime.now().millisecondsSinceEpoch.toString();
                });
              },
            ),
            const SizedBox(height: 32),

            // All styles preview
            Text(
              'All Available Styles',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: availableAvatarStyles.map((style) {
                return Column(
                  children: [
                    UserAvatar(
                      seed: _currentSeed,
                      style: style.id,
                      size: 64,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      style.name,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Simulated leaderboard
            Text(
              'Leaderboard Example',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _SimulatedLeaderboard(),
          ],
        ),
      ),
    );
  }
}

class _SimulatedLeaderboard extends StatelessWidget {
  final List<_LeaderboardEntry> _entries = const [
    _LeaderboardEntry(
      rank: 1,
      name: 'Alice',
      seed: 'alice-123',
      style: 'pixel-art',
      winRate: 95,
    ),
    _LeaderboardEntry(
      rank: 2,
      name: 'Bob',
      seed: 'bob-456',
      style: 'lorelei',
      winRate: 88,
    ),
    _LeaderboardEntry(
      rank: 3,
      name: 'Charlie',
      seed: 'charlie-789',
      style: 'bottts',
      winRate: 82,
    ),
    _LeaderboardEntry(
      rank: 4,
      name: 'Diana',
      seed: 'diana-abc',
      style: 'avataaars',
      winRate: 79,
    ),
    _LeaderboardEntry(
      rank: 5,
      name: 'Player',
      seed: 'eve-def',
      style: 'shapes',
      winRate: 75,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _entries
          .map((entry) => ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '#${entry.rank}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    UserAvatar(
                      seed: entry.seed,
                      style: entry.style,
                      size: 40,
                    ),
                  ],
                ),
                title: Text(entry.name),
                trailing: Text(
                  '${entry.winRate}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ))
          .toList(),
    );
  }
}

class _LeaderboardEntry {
  final int rank;
  final String name;
  final String seed;
  final String style;
  final int winRate;

  const _LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.seed,
    required this.style,
    required this.winRate,
  });
}
