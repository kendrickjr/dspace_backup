# repository
 
 This scrip is created to backup dspace database and the main pdf storage which is called 
 Asset store

follow the following steps:


Here is a sample script to make local backups which are then sent to the remote backup server.

Type the following.

sudo nano /backup.sh

Now copy and paste the following into the open editor and modify the backup variables to suit your location and server.

    Replace %hostname% with the hostname of your server.
    Replace %email-address% with the email address of the person responsible for server backups.
Change the permision to 777 then try to run it.

Navigate to /home/backup and see if u willl see the new backed up files. 
