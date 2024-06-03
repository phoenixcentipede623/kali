#!/usr/bin/bash

core_file="/home/core/menteeDeteails.txt"
#less than -lt
if ["$#" -lt 2];:
    echo " Usage: domainPref <roll_number> <domain1> [<domain2> [<domain3>]]"
    exit 1
fi

roll_number=$1

# very useful command shift
shift

#store all the domains he applied to
domains=("$@")

mentee_home="/home/core/mentees/$roll_number"
core_file="/home/core/mentees_domain.txt"
if [ ! -d "$mentee_home"]; then
    echo "Mentee home director not foung!"
    exit 20
fi

# add his pref to the hime doamin_pref file
#also make dir for each domain

for domain in "{doamin[@]}"; do
    echo "$domain" >> "$mentee_home/domain_pref.txt"
    mkdir "mentee_home/$domain"
done

# update the core file append 
echo "roll_number: {domains[*]}" >> "$core_file"

