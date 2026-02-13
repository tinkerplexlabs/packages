import 'package:flutter/foundation.dart';

/// Register CC BY 4.0 licenses for DiceBear avatar styles used in this package.
/// Call this in your app's main() before runApp() to ensure proper attribution
/// appears in Flutter's built-in licenses screen (showLicensePage).
void registerAvatarLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['DiceBear - Adventurer Style'],
      'Adventurer Avatar Style\n'
      'Created by: Lisa Wischofsky\n'
      'Licensed under: Creative Commons Attribution 4.0 International (CC BY 4.0)\n'
      'License URL: https://creativecommons.org/licenses/by/4.0/\n'
      'Source: https://www.dicebear.com/styles/adventurer\n'
      '\n'
      'This application uses the Adventurer avatar style from DiceBear.',
    );

    yield LicenseEntryWithLineBreaks(
      ['DiceBear - Fun Emoji Style'],
      'Fun Emoji Avatar Style\n'
      'Created by: Davis Uche\n'
      'Licensed under: Creative Commons Attribution 4.0 International (CC BY 4.0)\n'
      'License URL: https://creativecommons.org/licenses/by/4.0/\n'
      'Source: https://www.dicebear.com/styles/fun-emoji\n'
      '\n'
      'This application uses the Fun Emoji avatar style from DiceBear.',
    );

    yield LicenseEntryWithLineBreaks(
      ['DiceBear - Big Ears Style'],
      'Big Ears Avatar Style\n'
      'Created by: The Visual Team\n'
      'Licensed under: Creative Commons Attribution 4.0 International (CC BY 4.0)\n'
      'License URL: https://creativecommons.org/licenses/by/4.0/\n'
      'Source: https://www.dicebear.com/styles/big-ears\n'
      '\n'
      'This application uses the Big Ears avatar style from DiceBear.',
    );
  });
}
