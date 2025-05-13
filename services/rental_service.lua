local Item = require("models.item")
local Rental = require("models.rental")

local RentalService = {}
RentalService.__index = RentalService

function RentalService:new()
    local obj = {
        items = {},
        rentals = {}
    }
    setmetatable(obj, self)
    obj:load_items("data/items.txt")
    return obj
end

function RentalService:load_items(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Error: Unable to open items file.")
        return
    end
    local id = 1
    for line in file:lines() do
        table.insert(self.items, Item:new(id, line))
        id = id + 1
    end
    file:close()
end

function RentalService:list_items()
    for _, item in ipairs(self.items) do
        print(string.format("%d. %s", item.id, item.name))
    end
end

function RentalService:find_item_by_id(id)
    for _, item in ipairs(self.items) do
        if item.id == id then
            return item
        end
    end
    return nil
end

function RentalService:is_item_available(item, start_date, end_date)
    for _, rental in ipairs(self.rentals) do
        if rental.item.id == item.id and rental:overlaps(start_date, end_date) then
            return false
        end
    end
    return true
end

function RentalService:add_rental(rental)
    table.insert(self.rentals, rental)
end

function RentalService:get_active_rentals(current_date)
    local active = {}
    for _, rental in ipairs(self.rentals) do
        if rental:is_active(current_date) then
            table.insert(active, rental)
        end
    end
    return active
end

return RentalService
