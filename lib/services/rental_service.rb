require 'yaml'
require_relative '../models/item'
require_relative '../models/rental'

module Services
  class RentalService
    attr_reader :items, :rentals

    def initialize
      @items = load_items
      @rentals = []
    end

    def load_items
      items_data = YAML.load_file('data/items.yml')
      items_data.map.with_index(1) { |name, index| Models::Item.new(index, name) }
    end

    def list_items
      @items.each { |item| puts "#{item.id}. #{item.name}" }
    end

    def find_item_by_id(id)
      @items.find { |item| item.id == id }
    end

    def item_available?(item, start_date, end_date)
      @rentals.none? { |r| r.item.id == item.id && r.overlaps?(start_date, end_date) }
    end

    def add_rental(rental)
      @rentals << rental
    end

    def active_rentals
      @rentals.select(&:active?)
    end
  end
end
