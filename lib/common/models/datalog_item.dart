import 'package:polkawallet_plugin_zeitgeist/utils/hex_utils.dart';

class DatalogItem {
  DatalogItem(this.timestamp, this.jsonData);

  final int timestamp;
  final String jsonData;

  factory DatalogItem.fromJson(dynamic data) {
    final timestamp = data[0];
    final jsonData = HexUtils.fromHexString(data[1] as String);
    return DatalogItem(timestamp, jsonData);
  }
}
