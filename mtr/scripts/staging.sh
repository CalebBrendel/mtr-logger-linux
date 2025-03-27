#!/bin/bash

# MTR Logger Installation Script.
# Version  | 1.0.0
# Author   | Caleb Brendel
# Email    | caleb.brendel@basedment.org
# Website  | https://basedment.org

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                           Color Codes                                                                                           #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

RESET='\033[0m'
WHITE_R='\033[39m' # White
PURPLE='\033[0;35m' # Purple.
GREEN='\033[1;32m' # Light Green.

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                           Start Checks                                                                                          #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

header() {
  clear
  clear
  echo -e "${GREEN}#########################################################################${RESET}\\n"
}

header_red() {
  clear
  clear
  echo -e "${PURPLE}#########################################################################${RESET}\\n"
}

# Check for root (SUDO)

if [[ "$EUID" -ne 0 ]]; then
  clear && clear
  echo -e "${PURPLE}#########################################################################${RESET}\\n"
  echo -e "${WHITE_R}#${RESET} The script need to be run as root...\\n\\n"
  echo -e "${WHITE_R}#${RESET} For Ubuntu based systems run the command below to login as root"
  echo -e "${GREEN}#${RESET} sudo -i\\n"
  echo -e "${WHITE_R}#${RESET} For Debian based systems run the command below to login as root"
  echo -e "${GREEN}#${RESET} su\\n\\n"
  exit 1
fi

# Script Name Variable
script_name=$(basename "${BASH_SOURCE[0]}")

script_logo() {
  cat << "EOF"
         __           .__                                     
  ______/  |________  |  |   ____   ____   ____   ___________ 
 /     \   __\_  __ \ |  |  /  _ \ / ___\ / ___\_/ __ \_  __ \
|  Y Y  \  |  |  | \/ |  |_(  <_> ) /_/  > /_/  >  ___/|  | \/
|__|_|  /__|  |__|    |____/\____/\___  /\___  / \___  >__|   
      \/                         /_____//_____/      \/       

EOF
}

# Install dependencies needed: curl, cron, mtr & ftp-upload
sudo apt install curl cron mtr ftp-upload -y

# Create MTR directories to store cron job scripts and log files

cd /
sudo mkdir mtr
sudo mkdir /mtr/logs
sudo mkdir /mtr/logs/archive
sudo mkdir /mtr/scripts

# Set proper permissions for the directories

sudo chown -R $USER /mtr

# Downloading all scripts for MTR Logger

echo Now downloading all scripts needed to log packet loss

# Download the run mtr script - This runs for exactly 3595 packets (5 second buffer before the beginning of the hour)

curl -L https://raw.githubusercontent.com/CalebBrendel/mtr-logger-linux/refs/heads/main/mtr/scripts/run_mtr_every_hour.sh > /mtr/scripts/run_mtr_every_hour.sh

# Set the permissions of the mtr script to be executable

sudo chmod +x /mtr/scripts/run_mtr_every_hour.sh

# Creating cron jobs to run scripts...

# Cron job for creating archive directories at midnight every day

line="0 0 * * * ( sleep 1 ; /mtr/scripts/create_archive_dirs.sh )"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

# Cron job for moving the logs into the archive directories every day at the first minute

line="1 0 * * * ( sleep 4 ; /mtr/scripts/archive.sh )"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

# Crob job for MTR to run at the beginning of every hour

line="0 * * * * ( sleep 8 ; /mtr/scripts/run_mtr_every_hour.sh )"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

# Cron job for zipping the archive directory for the current date every day at the second minute

line="2 0 * * * ( sleep 10 ; /mtr/scripts/archive_zip.sh )"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

# Cron job for uploading the zip file for the current date to the ftp server every day at the third minute

line="3 0 * * * ( sleep 20 ; /mtr/scripts/ftp_upload.sh )"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

# Cron job for uploading the zip file for the current date to the ftp server every day at the fifth minute

line="5 0 * * * ( sleep 30 ; /mtr/scripts/del_zip.sh )"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
