#!/bin/bash

list_items() {
    local items_file="$1"
    echo ""
    echo "Available Items for Rent:"
    nl -w2 -s'. ' "$items_file"
}

