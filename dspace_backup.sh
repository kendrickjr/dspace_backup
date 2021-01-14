#!/bin/bash

# Setup shell to use for backups
SHELL=/bin/bash

# Setup name of local server to be backed up
SERVER="%hostname%"

# Setup event stamps
DOW=`date +%a`
TIME=`date`

# Setup paths
FOLDER="/home/backup"
FILE="/var/log/backup-$DOW.log"

# Do the backups
{
echo "Backup started: $TIME"

# Make the backup folder if it does not exist
if test ! -d /home/backup
then
  mkdir -p /home/backup
  echo "New backup folder created"
  else
  echo ""
fi

# Make sure we're in / since backups are relative to that
cd /

# Get a list of the installed software
dpkg --get-selections > $FOLDER/installed-software-$DOW.txt

## PostgreSQL database (Needs a /root/.pgpass file)
which -a psql
if [ $? == 0 ] ; then 
    echo "SQL dump of PostgreSQL databases"
    su - postgres -c "pg_dump --inserts dspace > /tmp/dspace-db.sql"
    cp /tmp/dspace-db.sql $FOLDER/dspace-db-$DOW.sql
    su - postgres -c "vacuumdb --analyze dspace > /dev/null 2>&1"
fi

# Backup MySQL database (Needs a /root/.my.cnf file)
which -a mysql
if [ $? == 0 ] ; then 
    echo "SQL dump of MySQL databases"
    mysqldump -A > $FOLDER/mysql-db-$DOW.sql
fi

# Backup '/etc' folder 
echo "Archive '/etc' folder"
tar czf $FOLDER/etc-$DOW.tgz etc/

# Backup '/root' folder
echo "Archive '/root' folder"
tar czf $FOLDER/root.tgz root/

# Backup '/usr/local' folder
echo "Archive '/usr/local' folder"
tar czf $FOLDER/usr-local.tgz usr/local/

# View backup folder
echo ""
echo "** Backup folder **"
ls -lhS $FOLDER

# Show disk usage
echo ""
echo "** Disk usage **"
df -h

TIME=`date`
echo "Backup ended: $TIME"

} > $FILE

# Prepare email
cat $FILE | mail -s "BACKUP : $DOW : $SERVER" %email-address%

### EOF ###
