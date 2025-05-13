import 'dart:io';
import 'models/item.dart';
import 'models/rental.dart';
import 'services/rental_service.dart';
import 'package:collection/collection.dart';

class App {
  final RentalService rentalService = RentalService();

  void run() {
    while (true) {
      _showMenu();
      final choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          _listItems();
          break;
        case '2':
          _rentItem();
          break;
        case '3':
          _listRentals();
          break;
        case '4':
          print('Exiting the application. Goodbye!');
          return;
        default:
          print('Invalid choice. Please try again.');
      }
    }
  }

  void _showMenu() {
    print('\n=== Rentable Application Menu ===');
    print('1. View Available Items');
    print('2. Rent an Item');
    print('3. View Current Rentals');
    print('4. Exit');
    stdout.write('Enter your choice: ');
  }

  void _listItems() {
    print('\nAvailable Items for Rent:');
    for (var item in rentalService.getAvailableItems()) {
      print('${item.id}. ${item.name}');
    }
  }

  void _rentItem() {
    _listItems();
    stdout.write('Enter the number of the item you wish to rent: ');
    final input = stdin.readLineSync();
    final itemId = int.tryParse(input ?? '');
    final item = rentalService.items.firstWhereOrNull((i) => i.id == itemId);
    if (item == null) {
      print('Invalid item selection.');
      return;
    }

    stdout.write('Enter the start date (YYYY-MM-DD): ');
    final startInput = stdin.readLineSync();
    stdout.write('Enter the end date (YYYY-MM-DD): ');
    final endInput = stdin.readLineSync();

    try {
      final startDate = DateTime.parse(startInput!);
      final endDate = DateTime.parse(endInput!);

      if (startDate.isBefore(DateTime.now())) {
        print('Start date cannot be in the past.');
        return;
      }

      if (endDate.difference(startDate).inDays < 1) {
        print('Rental period must be at least one day.');
        return;
      }

      if (!rentalService.isItemAvailable(item, startDate, endDate)) {
        final conflictingRental =
            rentalService.getConflictingRental(item, startDate, endDate);
        print(
            'Item is already rented during this period. Available after ${conflictingRental!.endDate.toLocal()}');
        return;
      }

      final rental = Rental(item, startDate, endDate);
      rentalService.addRental(rental);
      print(
          'Success: ${item.name} has been rented from $startDate to $endDate.');
    } catch (e) {
      print('Invalid date format. Please try again.');
    }
  }

  void _listRentals() {
    print('\nCurrent Rentals:');
    final activeRentals = rentalService.getActiveRentals();
    if (activeRentals.isEmpty) {
      print('No current rentals.');
    } else {
      for (var rental in activeRentals) {
        print(
            'Item: ${rental.item.name} | From: ${rental.startDate.toLocal()} | To: ${rental.endDate.toLocal()}');
      }
    }
  }
}
