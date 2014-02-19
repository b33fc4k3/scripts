#!/bin/bash

# Define the clock
Clock() {
        DATE=$(date "+%a %b %d, %T")

        echo -n "$DATE"
}

# Print the clock

while true; do
        echo "\c\f1\b0\u6 $(Clock)\ur"
        sleep 1;
done
