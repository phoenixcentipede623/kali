# Define alias commands
echo 'alias userGen="/home/core/scripts/userGen.sh"' >> ~/.bashrc
echo 'alias domainPref="/home/core/scripts/domainPref.sh"' >> ~/.bashrc
echo 'alias mentorAllocation="/home/core/scripts/mentorAllocation.sh"' >> ~/.bashrc
echo 'alias submitTask="/home/core/scripts/submitTask.sh"' >> ~/.bashrc
echo 'alias displayStatus="/home/core/scripts/displayStatus.sh"' >> ~/.bashrc
echo 'alias deRegister="/home/core/scripts/deRegister.sh"' >> ~/.bashrc
echo 'alias setQuiz="/home/core/scripts/setQuiz.sh"' >> ~/.bashrc

# Sourcing the .bashrc file to apply changes 
source ~/.bashrc



sudo chmod +x /home/core/scripts/*.sh



cd <path_to_files>
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/phoenixcentipede623/GeminiClub.git
git push -u origin master