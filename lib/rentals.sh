#!/bin/bash

rent_item() {
    local items_file="$1"
    local rentals_file="$2"

    echo ""
    echo "=== Rent an Item ==="
    list_items "$items_file"
    read -rp "Enter the item name you wish to rent: " item_name

    if ! grep -Fxq "$item_name" "$items_file"; then
        echo "Error: Item '$item_name' does not exist."
        return
    fi

    while true; do
        read -rp "Enter the start date (YYYY-MM-DD): " start_date
        if is_valid_date "$start_date"; then
            break
        else
            echo "Invalid date format. Please try again."
        fi
    done

    while true; do
        read -rp "Enter the end date (YYYY-MM-DD): " end_date
        if is_valid_date "$end_date"; then
            if is_minimum_one_day "$start_date" "$end_date"; then
                break
            else
                echo "Rental period must be at least one day."
            fi
        else
            echo "Invalid date format. Please try again."
        fi
    done

    if ! is_item_available "$item_name" "$start_date" "$end_date" "$rentals_file"; then
        return
    fi

    echo "$item_name|$start_date|$end_date" >> "$rentals_file"
    echo "Success: '$item_name' has been rented from $start_date to $end_date."
}

is_item_available() {
    local item="$1"
    local start_date="$2"
    local end_date="$3"
    local rentals_file="$4"
    local start_epoch
    local end_epoch
    start_epoch=$(date -d "$start_date" +%s)
    end_epoch=$(date -d "$end_date" +%s)

    while IFS='|' read -r rented_item rented_start rented_end; do
        # Skip expired rentals
        if [[ "$(date -d "$rented_end" +%s)" -lt "$(date +%s)" ]]; then
            continue
        fi
        if [[ "$rented_item" == "$item" ]]; then
            rented_start_epoch=$(date -d "$rented_start" +%s)
            rented_end_epoch=$(date -d "$rented_end" +%s)
            # Check for overlap
            if [[ $start_epoch -lt $rented_end_epoch && $end_epoch -gt $rented_start_epoch ]]; then
                echo "Error: '$item' is already rented during this period."
                echo "It will be available again after $rented_end."
                return 1
            fi
        fi
    done < "$rentals_file"
    return 0
}

list_rentals() {
    local rentals_file="$1"
    echo ""
    echo "=== Current Rentals ==="
    local current_date_epoch
    current_date_epoch=$(date +%s)
    local found=0
    while IFS='|' read -r item start_date end_date; do
        end_date_epoch=$(date -d "$end_date" +%s)
        if [[ $end_date_epoch -ge $current_date_epoch ]]; then
            echo "Item: $item | From: $start_date | To: $end_date"
            found=1
        fi
    done < "$rentals_file"

    if [[ $found -eq 0 ]]; then
        echo "No current rentals."
    fi
}

