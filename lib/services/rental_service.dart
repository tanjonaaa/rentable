import '../models/item.dart';
import '../models/rental.dart';

class RentalService {
  final List<Item> items = [];
  final List<Rental> rentals = [];

  RentalService() {
    _populateItems();
  }

  void _populateItems() {
    items.addAll([
      Item(1, 'Camera'),
      Item(2, 'Bicycle'),
      Item(3, 'Laptop'),
      Item(4, 'Projector'),
    ]);
  }

  List<Item> getAvailableItems() {
    return items;
  }

  bool isItemAvailable(Item item, DateTime start, DateTime end) {
    for (var rental in rentals) {
      if (rental.item.id == item.id && rental.overlaps(start, end)) {
        return false;
      }
    }
    return true;
  }

  Rental? getConflictingRental(Item item, DateTime start, DateTime end) {
    for (var rental in rentals) {
      if (rental.item.id == item.id && rental.overlaps(start, end)) {
        return rental;
      }
    }
    return null;
  }

  void addRental(Rental rental) {
    rentals.add(rental);
  }

  List<Rental> getActiveRentals() {
    return rentals.where((r) => r.isActive()).toList();
  }
}
