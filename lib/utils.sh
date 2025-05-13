#!/bin/bash

initialize_data_files() {
    local items_file="$1"
    local rentals_file="$2"

    if [[ ! -f "$items_file" ]]; then
        cat <<EOL > "$items_file"
Camera
Bicycle
Laptop
Projector
EOL
    fi

    touch "$rentals_file"
}

is_valid_date() {
    date -d "$1" "+%Y-%m-%d" >/dev/null 2>&1
    return $?
}

is_minimum_one_day() {
    local start_date="$1"
    local end_date="$2"
    local start_epoch
    local end_epoch
    start_epoch=$(date -d "$start_date" +%s)
    end_epoch=$(date -d "$end_date" +%s)
    local diff=$(( (end_epoch - start_epoch) / 86400 ))
    [[ $diff -ge 1 ]]
}

