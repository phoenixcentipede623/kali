#!/bin/bash
MYSQL_PWD=password mysqldump -u user -h db userdb > /backups/db_backup_$(date +\%F_\%T).sql
