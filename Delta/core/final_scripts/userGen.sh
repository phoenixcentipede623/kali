#!/bin/bash
{
read 
while IFS=' ' read -r name domain capacity; do
    mentor="$domain"_"$name"
    echo "$mentor"
    echo "$name $domain $capacity"
    if ! id -u "$mentor" &>/dev/null; then
	echo 1
        sudo useradd -m -d "file/$domain" "$mentor"
    fi
    # we redefine mentor_home to this specific mentor
    sudo mkdir -p "mentors/$domain/$mentor"
    echo "The absolute path of the new directory is: $(readlink -f $mentor)"
    echo "The absolute path of the new directory is: $(realpath $mentor)" 

    echo "$?"  
    sudo touch "mentors/$domain/$mentor/allocatedMentees.txt"
    echo "$?"
    for i in {1..3}; do
        sudo mkdir -p "mentors/$domain/$mentor/submittedTasks/task$i"
    done
done
} < "mentorDetails.txt"

#!/bin/bash

{
read
while IFS=" " read -r mentee_roll name domains; do
    if ! id -u "$mentee_roll" &>/dev/null; then
        sudo useradd -m -d mentees "$mentee_roll"
    fi
    sudo mkdir -p "mentee/$mentee_roll"
    mentee_home="mentee/$mentee_roll"
    
    sudo touch "mentee/$mentee_roll/domain_pref.txt"
    sudo touch "mentee/$mentee_roll/task_submitted.txt"
    sudo touch "mentee/$mentee_roll/task_completed.txt"
   

    echo "domain pref order $domains"
    # getting the domain array
    domain_temp=$(echo "$domains" | sed s/"->"/" "/g)
	#string to array
    read -ra domain_pref <<< "$domain_temp"

    for domain in "${domain_pref[@]}"; do
	echo "creating $domain file for $mentee_roll"
        sudo mkdir -p "mentee/$mentee_roll/$domain" 
        for i in {1..3}; do
	    
            sudo mkdir -p "mentee/$mentee_roll/$domain/task$i"
            a="mentee/$mentee_roll/$domain/task$i"
	    #echo "The absolute path of the new directory is: $(readlink -f $a)"
   	    #echo "The absolute path of the new directory is: $(realpath $a)" 
        done
    done
done
}< "mentees_domain.txt"

