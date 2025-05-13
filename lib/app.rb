require 'date'
require_relative 'rental_service'

class App
  def initialize
    @service = RentalService.new
  end

  def run
    loop do
      display_menu
      choice = gets.chomp
      case choice
      when '1'
        list_items
      when '2'
        rent_item
      when '3'
        list_rentals
      when '4'
        puts 'Exiting the application. Goodbye!'
        break
      else
        puts 'Invalid choice. Please try again.'
      end
    end
  end

  private

  def display_menu
    puts "\n=== Rental Application Menu ==="
    puts '1. View Available Items'
    puts '2. Rent an Item'
    puts '3. View Current Rentals'
    puts '4. Exit'
    print 'Enter your choice: '
  end

  def list_items
    puts "\nAvailable Items for Rent:"
    @service.list_items
  end

  def rent_item
    list_items
    print 'Enter the number of the item you wish to rent: '
    item_id = gets.chomp.to_i
    item = @service.find_item_by_id(item_id)
    unless item
      puts 'Invalid item selection.'
      return
    end

    print 'Enter the start date (YYYY-MM-DD): '
    start_input = gets.chomp
    print 'Enter the end date (YYYY-MM-DD): '
    end_input = gets.chomp

    begin
      start_date = Date.parse(start_input)
      end_date = Date.parse(end_input)

      if (end_date - start_date).to_i < 1
        puts 'Rental period must be at least one day.'
        return
      end

      if @service.item_available?(item, start_date, end_date)
        rental = Rental.new(item, start_date, end_date)
        @service.add_rental(rental)
        puts "Success: #{item.name} has been rented from #{start_date} to #{end_date}."
      else
        puts 'Item is already rented during this period.'
      end
    rescue ArgumentError
      puts 'Invalid date format. Please try again.'
    end
  end

  def list_rentals
    puts "\nCurrent Rentals:"
    rentals = @service.active_rentals
    if rentals.empty?
      puts 'No current rentals.'
    else
      rentals.each do |rental|
        puts "Item: #{rental.item.name} | From: #{rental.start_date} | To: #{rental.end_date}"
      end
    end
  end
end
