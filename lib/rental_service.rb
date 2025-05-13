require 'yaml'
require_relative 'item'
require_relative 'rental'

class RentalService
  attr_reader :items, :rentals

  def initialize
    @items = load_items
    @rentals = []
  end

  def load_items
    items_data = YAML.load_file('data/items.yml')
    items_data.map.with_index(1) { |name, index| Item.new(index, name) }
  end

  def list_items
    @items.each do |item|
      puts "#{item.id}. #{item.name}"
    end
  end

  def find_item_by_id(id)
    @items.find { |item| item.id == id }
  end

  def item_available?(item, start_date, end_date)
    @rentals.none? do |rental|
      rental.item.id == item.id && rental.overlaps?(start_date, end_date)
    end
  end

  def add_rental(rental)
    @rentals << rental
  end

  def active_rentals
    @rentals.select(&:active?)
  end
end
