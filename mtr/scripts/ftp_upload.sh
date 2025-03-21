# Script to upload mtr logs to an ftp server to view the logs and download the logs

# Needed dependencies: ftp-upload (ubuntu/debian package)

sudo apt install ftp-upload

# Remove the server, user, and password fields and populate them with the correct information

cd /mtr/logs/archive

ftp-upload -h {SERVER} -u {USER} --password {PASSWORD} *.txt

