import 'item.dart';

class Rental {
  final Item item;
  final DateTime startDate;
  final DateTime endDate;

  Rental(this.item, this.startDate, this.endDate);

  bool isActive() {
    final now = DateTime.now();
    return endDate.isAfter(now);
  }

  bool overlaps(DateTime start, DateTime end) {
    return start.isBefore(endDate) && end.isAfter(startDate);
  }
}
