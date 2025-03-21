# Deletes the zip file created on the current date at the fifth minute every day after uploading it to the server

sudo rm /mtr/logs/archive/""`date +"%m-%d-%Y"`.zip
