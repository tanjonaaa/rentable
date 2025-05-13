local Rental = {}
Rental.__index = Rental

function Rental:new(item, start_date, end_date)
    local obj = {
        item = item,
        start_date = start_date,
        end_date = end_date
    }
    setmetatable(obj, self)
    return obj
end

function Rental:is_active(current_date)
    return self.end_date >= current_date
end

function Rental:overlaps(start_date, end_date)
    return self.start_date <= end_date and start_date <= self.end_date
end

return Rental
