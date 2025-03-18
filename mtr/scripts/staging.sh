#!/bin/bash

echo MTR Logger created by Caleb Brendel

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

# List of dependencies needed: curl, cron & mtr

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


echo Creating cron jobs to run scripts 

# Crob job for MTR to run at the beginning of every hour

line="0 * * * * mtr/scripts/run_mtr_every_hour.sh"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

# Cron job for creating archive directories at midnight every day

line="0 0 * * * mtr/scripts/create_archive_dirs.sh"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

# Cron job for moving the logs into the archvie directories

line="1 0 * * * mtr/scripts/archive.sh"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
