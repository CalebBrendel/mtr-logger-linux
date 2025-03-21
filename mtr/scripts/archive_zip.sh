# Zipping current date directory for ftp transfer...

zip -r /mtr/logs/archive/""`date +"%m-%d-%Y"`.zip /mtr/logs/archive/""`date +"%m-%d-%Y"`

# Ensures proper permissions to transfer the file - Not super insecure due to the fact the zip file is deleted two minutes later...lol

sudo chmod 777 /mtr/logs/archive/""`date +"%m-%d-%Y"`.zip

# First date command is for grabbing the current date and inserting it into the name of the zip file

# Second date command is for grabbing the current date folder as that is the only folder needing to be zipped
