import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  static String convertToIndonesianDate(String dateString) {
    try {
      // Parse the input date string
      DateTime dateTime = DateTime.parse(dateString);

      // Define the output format
      DateFormat dateFormat = DateFormat("dd MMMM yyyy", "id_ID");

      // Format the date
      return dateFormat.format(dateTime);
    } catch (e) {
      // Handle parsing error
      return "Invalid date";
    }
  }

  static String convertToYMDFormat(String indonesianDateString) {
    try {
      // Define the input format
      DateFormat inputFormat = DateFormat("dd MMMM yyyy");

      // Parse the input date string
      DateTime dateTime = inputFormat.parse(indonesianDateString);

      // Define the output format
      DateFormat outputFormat = DateFormat("yyyy-MM-dd");

      // Format the date
      return outputFormat.format(dateTime);
    } catch (e) {
      // Handle parsing error
      return "Invalid date";
    }
  }

  static String convertToYMDFormatFromCurrentDate(DateTime date) {
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    return outputFormat.format(date);
  }

  static String formatScheduledAt(DateTime date, TimeOfDay time) {
    // Combine DateTime and TimeOfDay into a single DateTime object
    final combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Define the output format
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    // Format and return the combined DateTime
    return formatter.format(combinedDateTime);
  }

  static String getMonthName(DateTime date) {
    // Define the month format
    final DateFormat monthFormat = DateFormat('MMMM', 'id_ID');

    // Format and return the month name
    return monthFormat.format(date);
  }

  static String extractTimeWithoutSeconds(DateTime dateTime) {
    // Define the 24-hour time format without seconds
    final DateFormat timeFormat = DateFormat('HH:mm');

    // Format and return the time part
    return timeFormat.format(dateTime);
  }
}
