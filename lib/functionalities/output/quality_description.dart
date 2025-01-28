class QualityDescription {
  static String getDescription(String quality) {
    switch (quality) {
      case 'excellent':
        return 'Excellent quality is the best choice. It maximizes target market potential and is suitable for import.';
      case 'good':
        return 'Good quality has minor defects and is not recommended for import, but is acceptable for supermarket standards.';
      case 'fair':
        return 'Fair quality has moderate defects and limited marketability.';
      case 'poor':
        return 'Poor quality shows serious defects. While not suitable for human consumption, it can be used for feeding animals.';
      case 'non edible':
        return 'Non-edible quality means it is not recommended for consumption by humans or animals, but it can serve as good fertilizer.';
      default:
        return 'Quality unknown.';
    }
  }

  static double getFreshnessRate(String quality) {
    switch (quality) {
      case 'excellent':
        return 8; // Average of 8 and 9
      case 'good':
        return 7; // Average of 6 and 8
      case 'fair':
        return 5; // Fair quality
      case 'poor':
        return 3; // Average of 3 and 5
      case 'non edible':
        return 1; // Average of 1 and 2
      default:
        return 0.0; // Unknown quality
    }
  }
}
