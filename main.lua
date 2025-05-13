local RentalService = require("services.rental_service")

local function parse_date(input)
    local year, month, day = input:match("(%d+)-(%d+)-(%d+)")
    if year and month and day then
        return os.time({ year = tonumber(year), month = tonumber(month), day = tonumber(day) })
    else
        return nil
    end
end

local function format_date(timestamp)
    return os.date("%Y-%m-%d", timestamp)
end

local function main()
    local service = RentalService:new()
    while true do
        print("\n=== Rental Application Menu ===")
        print("1. View Available Items")
        print("2. Rent an Item")
        print("3. View Current Rentals")
        print("4. Exit")
        io.write("Enter your choice: ")
        local choice = io.read()
        if choice == "1" then
            print("\nAvailable Items for Rent:")
            service:list_items()
        elseif choice == "2" then
            service:list_items()
            io.write("Enter the number of the item you wish to rent: ")
            local item_id = tonumber(io.read())
            local item = service:find_item_by_id(item_id)
            if not item then
                print("Invalid item selection.")
            else
                io.write("Enter the start date (YYYY-MM-DD): ")
                local start_input = io.read()
                io.write("Enter the end date (YYYY-MM-DD): ")
                local end_input = io.read()
                local start_date = parse_date(start_input)
                local end_date = parse_date(end_input)
                if not start_date or not end_date then
                    print("Invalid date format. Please try again.")
                elseif end_date <= start_date then
                    print("Rental period must be at least one day.")
                elseif service:is_item_available(item, start_date, end_date) then
                    local rental = require("models.rental"):new(item, start_date, end_date)
                    service:add_rental(rental)
                    print(string.format("Success: %s has been rented from %s to %s.", item.name, format_date(start_date), format_date(end_date)))
                else
                    print("Item is already rented during this period.")
                end
            end
        elseif choice == "3" then
            print("\nCurrent Rentals:")
            local current_date = os.time()
            local rentals = service:get_active_rentals(current_date)
            if #rentals == 0 then
                print("No current rentals.")
            else
                for _, rental in ipairs(rentals) do
                    print(string.format("Item: %s | From: %s | To: %s", rental.item.name, format_date(rental.start_date), format_date(rental.end_date)))
                end
            end
        elseif choice == "4" then
            print("Exiting the application. Goodbye!")
            break
        else
            print("Invalid choice. Please try again.")
        end
    end
end

main()
