import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class StorageService {
  static const String _prefix = 'day_data_';
  static const String _datesKey = 'all_dates';

  Future<DayData> loadDay(String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString('$_prefix$date');
    if (raw == null) return DayData.empty(date);
    try {
      return DayData.decode(date, raw);
    } catch (_) {
      return DayData.empty(date);
    }
  }

  Future<void> saveDay(DayData data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix${data.date}', data.encode());
    final List<String> dates = prefs.getStringList(_datesKey) ?? <String>[];
    if (!dates.contains(data.date)) {
      dates.add(data.date);
      await prefs.setStringList(_datesKey, dates);
    }
  }
}
