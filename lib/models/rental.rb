require 'date'

module Models
  class Rental
    attr_reader :item, :start_date, :end_date

    def initialize(item, start_date, end_date)
      @item = item
      @start_date = start_date
      @end_date = end_date
    end

    def active?
      @end_date >= Date.today
    end

    def overlaps?(start_date, end_date)
      (@start_date <= end_date) && (start_date <= @end_date)
    end
  end
end
