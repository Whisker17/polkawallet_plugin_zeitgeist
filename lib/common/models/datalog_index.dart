class DatalogIndex {
  DatalogIndex(this.start, this.end);

  final int start;
  final int end;

  factory DatalogIndex.fromJson(dynamic data) {
    final json = data as Map<String, dynamic>;
    final start = json['start'] as int;
    final end = json['end'] as int;
    return DatalogIndex(start, end);
  }
}
