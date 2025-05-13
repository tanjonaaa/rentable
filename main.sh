#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/menu.sh"
source "$SCRIPT_DIR/lib/items.sh"
source "$SCRIPT_DIR/lib/rentals.sh"

mkdir -p "$SCRIPT_DIR/data"

initialize_data_files "$SCRIPT_DIR/data/items.txt" "$SCRIPT_DIR/data/rentals.txt"

while true; do
    show_menu
    read -rp "Enter your choice: " choice
    case $choice in
        1) list_items "$SCRIPT_DIR/data/items.txt" ;;
        2) rent_item "$SCRIPT_DIR/data/items.txt" "$SCRIPT_DIR/data/rentals.txt" ;;
        3) list_rentals "$SCRIPT_DIR/data/rentals.txt" ;;
        4) echo "Exiting the application. Goodbye!"; break ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
done

