/// Extracts human-readable valid characters from a regex pattern.
///
/// This is useful for presenting a user-friendly message about what characters are allowed.
/// Note: This works best with simple character class patterns like [a-zA-Z0-9_-].
String extractValidCharactersFromRegex(String regexPattern) {
  // Handle common character classes
  final result = StringBuffer();

  // Process the pattern looking for character classes [...]
  final charClassRegex = RegExp(r'\[(.*?)\]');
  final matches = charClassRegex.allMatches(regexPattern);

  for (final match in matches) {
    final charClass = match.group(1) ?? '';

    // Process ranges like a-z, A-Z, 0-9
    final rangeRegex = RegExp(r'(\w)-(\w)');
    final rangified = charClass.replaceAllMapped(rangeRegex, (rangeMatch) {
      final start = rangeMatch.group(1)!.codeUnitAt(0);
      final end = rangeMatch.group(2)!.codeUnitAt(0);

      if (start <= end) {
        final chars = List.generate(
            end - start + 1, (i) => String.fromCharCode(start + i)).join('');
        return chars;
      }
      return rangeMatch.group(0)!;
    });

    // Remove escape characters and add to result
    result.write(rangified.replaceAll(r'\', ''));
  }

  // Handle regex outside character classes if needed
  // This is a simplified implementation and may need enhancement
  // for complex regex patterns

  return result.toString();
}
