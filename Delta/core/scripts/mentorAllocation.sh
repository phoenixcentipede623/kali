#!/usr/bin/bash

mentor_details="/home/core/mentorDetails"
mentee_details="/home/core/menteeDetails"
mentees=($( awk '{for(i=2;i<NF;i++) print $2}' "$mentee_deatils"))

#arrays to keep track of allocated and capacity
declare -A mentor_capacity
declare -A mentors_allocated
declare -A domain_mentors

#omiting first line
read -r _< "mentor_details"
while read -r name domain capacity; do

    mentor_capacity[$name]=$capacity
    mentees_allocated[$name]=0
    domain_mentors["$domain"]+="$name "
    
done < "mentor_details"

# allocate_mentor function :-( dont make mistake re-check

allocate_mentee() {

    local mentee=$1
    local domain=$2
    local mentors=(${domain_mentors[$domain]})

    for mentor in "${$mentors[@]}"; do
        if [ "${mentees_allocated[$mentor]}" -lt "${mentor_capacity[$mentor]}" ]; then
            echo "$mentee" >> "/home/core/mentors/${domain}_mentor/$mentor/allocatedMentees.txt"
            return 0
        fi
    done
    return 1
}


#  ^ -> start of line || using the return 1 or 0 to terminate loop
for mentee in "${mentees[@]}"; do
    domains=($(grep "^$mentee" /home/core/mentees_domain.txt| cut -d" " -f3- | tr "->" " " ))
    
    for domain in "${domains[@]}"; do  
        if allocate_mentor "$mentee" "$domain";
            break
        fi
    done      
