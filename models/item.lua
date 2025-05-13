local Item = {}
Item.__index = Item

function Item:new(id, name)
    local obj = { id = id, name = name }
    setmetatable(obj, self)
    return obj
end

return Item
