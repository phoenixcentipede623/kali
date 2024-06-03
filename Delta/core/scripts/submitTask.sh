#!/usr/bin/bash

# Function to handle mentee task submission
mentee_submit_task() {
    local task_name="$1"
    local mentee_home="/home/core/mentee/$USER"
    local mentee_task_submitted_file="$mentee_home/task_submitted.txt"
    local mentee_task_completed_file="$mentee_home/task_completed.txt"
    local mentees_domain_file="/home/core/mentees_domain.txt"

    # Get the mentee's domain preferences
    local domains=($(grep "^$USER:" $mentees_domain_file | cut -d: -f2- | tr '->' ' '))

    # Append task submission details
    echo "$task_name submitted by $USER" >> "$mentee_task_submitted_file"

    # Generate corresponding task folders under each domain chosen
    for domain in "${domains[@]}"; do
        mkdir -p "$mentee_home/$domain/$task_name"
    done

    echo "Task $task_name has been submitted."
}

# Function to handle mentor task processing
mentor_process_tasks() {
    local mentor_home="/home/mentor/$USER"
    local allocated_mentees_file="$mentor_home/allocatedMentees.txt"
    local submitted_tasks_dir="$mentor_home/submittedTasks"
    local mentee_task_completed_file="$mentee_home/task_completed.txt"

    while IFS= read -r mentee; do
        local mentee_name=$(echo "$mentee" | cut -d ' ' -f1)
        local mentee_roll=$(echo "$mentee" | cut -d ' ' -f2)
        local mentee_home="/home/core/mentees/$mentee_name"
        
        # Create symlinks for each task directory from mentee to mentor
        for task_dir in "$mentee_home"/*/; do
            task_name=$(basename "$task_dir")
            if [ -d "$task_dir" ]; then
                ln -s "$task_dir" "$submitted_tasks_dir/$task_name/$mentee_name"
                
                # Check if task is completed (not empty)
                if [ "$(ls -A "$task_dir")" ]; then
                    echo "$task_name completed by $mentee_name" >> "$mentee_task_completed_file"
                fi
            fi
        done
    done < "$allocated_mentees_file"
    
    echo "Tasks processed for mentor $USER."
}

if [[ "$USER" == *mentor* ]]; then
    mentor_process_tasks
else
    if [ -z "$1" ]; then
        echo "Usage: submitTask <task_name>"
        exit 1
    fi
    mentee_submit_task "$1"
fi
