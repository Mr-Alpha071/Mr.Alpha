import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

/// مسؤول عن حفظ واسترجاع بيانات الأيام محليًا على الجهاز
class StorageService {
  static const _prefix = 'day_data_';
  static const _datesKey = 'all_dates';

  Future<DayData> loadDay(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$date');
    if (raw == null) {
      return DayData.empty(date);
    }
    try {
      return DayData.decode(date, raw);
    } catch (_) {
      return DayData.empty(date);
    }
  }

  Future<void> saveDay(DayData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix${data.date}', data.encode());
    final dates = prefs.getStringList(_datesKey) ?? [];
    if (!dates.contains(data.date)) {
      dates.add(data.date);
      await prefs.setStringList(_datesKey, dates);
    }
  }

  Future<List<String>> allDates() async {
    final prefs = await SharedPreferences.getInstance();
    final dates = prefs.getStringList(_datesKey) ?? [];
    dates.sort();
    return dates;
  }
}
