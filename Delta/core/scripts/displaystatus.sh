#!/usr/bin/bash

# Function to display status
local core_dir="/home/core"
local mentees_dir="$core_dir/mentees"
local mentors_dir="$core_dir/mentors"
last_checked_file="$core_dir/.last_checked"


display_status() {
    local domain="$1"
    
    local tasks=("task1" "task2" "task3")
    local mentees=($(ls -1 $mentees_dir))
    local total_mentees=${#mentees[@]}
    local last_checked_time=0

    # Read the last checked time if the file exists
    if [[ -f $last_checked_file ]]; then
        last_checked_time=$(cat $last_checked_file)
    fi

    echo "Total Mentees: $total_mentees"

    for task in "${tasks[@]}"; do
        local submitted_count=0
        local submitted_mentees=()
        for mentee in "${mentees[@]}"; do
            local mentee_task_dir="$mentees_dir/$mentee/$domain/$task"
            if [[ -d "$mentee_task_dir" && "$(ls -A $mentee_task_dir)" ]]; then
                submitted_count=$((submitted_count + 1))
                submitted_mentees+=("$mentee")
            fi
        done

        local percentage=$(echo "scale=2; ($submitted_count/$total_mentees)*100" | bc)
        echo "Task: $task"
        echo "Submitted: $submitted_count/$total_mentees ($percentage%)"
        echo "$task"
        echo "Mentees who submitted since last check:"
        
        for mentee in "${submitted_mentees[@]}"; do
            local mentee_last_modified=$(stat -c %Y "$mentees_dir/$mentee/$task")
            if [[ $mentee_last_modified -gt $last_checked_time ]]; then
                echo " - $mentee"
            fi
        
        done
    done
    date +%s > $last_checked_file
}

# Main execution
if [[ -n "$1" ]]; then
    display_status "$1"
else
    display_status
fi
