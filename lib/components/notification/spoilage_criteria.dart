// spoilage_criteria.dart

import 'package:intl/intl.dart';

class SpoilageCriteria {
  Map<String, Map<String, int>> shelfLifeData = {
    "broccoli": {
      "excellent_refrigerated": 14,
      "excellent_non_refrigerated": 4,
      "good_refrigerated": 10,
      "good_non_refrigerated": 3,
      "fair_refrigerated": 5,
      "fair_non_refrigerated": 1,
    },
    "cauliflower": {
      "excellent_refrigerated": 21,
      "excellent_non_refrigerated": 7,
      "good_refrigerated": 14,
      "good_non_refrigerated": 4,
      "fair_refrigerated": 10,
      "fair_non_refrigerated": 3,
    },
    "cabbage": {
      "excellent_refrigerated": 28,
      "excellent_non_refrigerated": 14,
      "good_refrigerated": 21,
      "good_non_refrigerated": 7,
      "fair_refrigerated": 14,
      "fair_non_refrigerated": 5,
    },
    "capsicum": {
      "excellent_refrigerated": 14,
      "excellent_non_refrigerated": 7,
      "good_refrigerated": 10,
      "good_non_refrigerated": 5,
      "fair_refrigerated": 7,
      "fair_non_refrigerated": 3,
    },
    "napa cabbage": {
      "excellent_refrigerated": 14,
      "excellent_non_refrigerated": 6,
      "good_refrigerated": 10,
      "good_non_refrigerated": 3,
      "fair_refrigerated": 7,
      "fair_non_refrigerated": 2,
    },
  };

  // Calculate the spoilage date based on the storage date, quality, and storage condition.
  DateTime calculateSpoilageDate(
      String date,
      String time,
      String quality,
      String storage,
      String vegetableType,
      ) {
    // Parse the input date and time
    DateTime storedDate = DateFormat('yyyy-MM-dd').parse(date);
    DateTime storedTime = DateFormat('HH:mm:ss').parse(time);
    DateTime storedDateTime = DateTime(
      storedDate.year,
      storedDate.month,
      storedDate.day,
      storedTime.hour,
      storedTime.minute,
      storedTime.second,
    );

    // Combine quality and storage type to find the shelf life
    String storageKey = storage.toLowerCase() == 'refrigerated' ? 'refrigerated' : 'non_refrigerated';

    String key = '${quality.toLowerCase()}_${storageKey}';

    // Use the vegetableType passed to this method
    int shelfLifeDays = shelfLifeData[vegetableType.toLowerCase()]?[key] ?? 0;

    // Calculate the spoilage date by adding shelf life days to the stored date
    return storedDateTime.add(Duration(days: shelfLifeDays));
  }

  // Calculate the remaining days until spoilage.
  int getRemainingDaysUntilSpoilage(DateTime spoilageDate) {
    Duration difference = spoilageDate.difference(DateTime.now());
    return difference.inDays;
  }
}
