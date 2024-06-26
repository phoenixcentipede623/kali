#!/usr/bin/bash

deregistrationChech_path= PATH
displayStatus_path= Path

core_home="/home/core"
mentors_home="$core_home/mentors"
mentees_home="$core_home/mentees"
domains=("Webdev" "Appdev" "Sysad")


if ! id -u core &>/dev/null; then
    sudo useradd -m core
fi

sudo mkdir -p /home/$core/mentors /home/$core/mentees


sudo chmod 755 "$core_home"





for domain in "{domains[@]}"; do
    sudo mkdir -p "$mentors_home/$domain"
done

#Creating mentor users and moving home to right place
while IFS=' ' read -r name domain capacity; do
    mentor="$domain"_"$name"
    if ! id -u "$mentor" &>/dev/null; then
        sudo useradd -m "$mentor"
    fi
    # we redefine mentor_home to this specific mentor
    local mentor_home="$mentees_home/$domain/$mentor"
    sudo mkdir -p "$mentors_home"
    sudo mv "/home/$mentor" "$mentors_home"
    sudo touch "$mentors_home/allocatedMentees.txt"

    for i in {1..3}; do
        sudo mkdir -p $mentors_home/submittedTasks/task$i
    done

done < "mentorDetails.txt"


"""
#Creating mentor users and moving home to right place
    sudo useradd -m $mentor
    sudo mkdir /home/$core/mentors/$mentor
    sudo mv /home/$mentor /home/$core/mentors/$mentor

    #files
    sudo touch /home/$core/mentors/$mentor/allocatedMentees.txt
    sudo mkdir /home/$core/mentors/$mentor/submittedTasks
    sudo mkdir /home/$core/mentors/$mentor/submittedTasks/task1 /home/$core/mentors/$mentor/submittedTasks/task2 /home/$core/mentors/$mentor/submittedTasks/task3
    '''
    will this work!!
    for i in {1..3}; do
        sudo mkdir /home/$core/domain/$mentor/submittedTasks/task$i
    '''
done
"""
#Creating mentee users....and adding respectivefiles
while IFS=' ' read -r mentee_roll name domains; do
    
    if ! id -u "$mentee_roll" &>/dev/null; then
        sudo useradd -m "$mentee_roll"
    fi
    #same here
    local mentees_home="$mentees_home/$mentee_roll"
    sudo mkdir -p "$mentees_home"
    sudo mv "/home/$mentee" "$mentee_home"
    
    
    sudo touch $mentee_home/domain_pref.txt
    sudo touch $mentee_home/task_submitted.txt
    sudo touch $mentee_home/task_completed.txt


    IFS="->" read -r -a domain_pref <<< "$domains"
    for domain in "${domain_pref[@]}"; do
        sudo mkdir "mentee_home/$domain"
        for i in {1..3}; do
            sudo mkdir -p $mentee_home/$domain/task$i
        done
    done
done < "mentees_domain.txt"

# Permissions
 # $mentor home wont create issues as variable are only defined within the scope
#sudo chmod 700 "$mentors_home"/* "$mentees_home"/*

sudo chmod -R 700 "$mentors_home" "$mentees_home"




sudo touch "/home/$core/mentees_doamin.txt"
sudo chmod 722 "/home/$core/mentees_doamin.txt"

sudo touch "/home/$core/menteeDetails.txt"
sudo touch "/home/$core/mentorDetails.txt"
sudo chmod 644 "/home/$core/menteeDetails.txt"
sudo chmod 644 "/home/$core/mentorDetails.txt"


# permissions

sudo chmod 755 /home/$core
sudo chmod 700 /home/$core/mentors/* /home/$core/mentees/*

sudo chmod 777 /home/$core/mentees


# cronjob for displayStatus
(crontab -l ; echo "0 0 * * * $displayStatus_path") | crontab -

# cronjob for deregistration check
(crontab -l ; echo "10 10 * * 0,3 $deregistrationChech_path") | crontab -

echo "Done Setting up! @#$ "