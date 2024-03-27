#!/bin/bash

# Prompt the user for their age and country
read -p "Your age? " age
read -p "Your country? " country

# Check if the user is eligible to vote
if [ "$age" -ge 18 ] && [ "$country" = "india" ]; then
    echo "You can vote."
else
    echo "You can't vote."
fi

