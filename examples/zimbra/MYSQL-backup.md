### MySQL Backup and Restore
The Zimbra Data Store is a MySQL database that contains all the metadata
regarding the messages including tags, conversations, and pointers to where the
messages are stored in the file system.

Each account (mailbox) resides only on one server. Each Zimbra server has its
own stand alone data store containing data for the mailboxes on that server.

### The Zimbra data store contains:
* Mailbox-account mapping: The primary identifier with the Zimbra database is the mailbox ID, rather than a username or account name. The mailbox ID is only unique within a single mailbox server. The data store maps the Zimbra mailbox IDs to the user's OpenLDAP accounts.
* Each user's set of tag definitions, folders, and contacts, calendar appointments, tasks notebooks, and filter rules.
* Information about each mail message, including whether it is read or unread, and which tags are associated.

### Overview
Sites that need an extra level of redundancy for their MySQL data can use the MySQL Binary Log and mysqldump. mysqldump is used to dump all the data in the database to a SQL script file. Data changes that occur later than the dumpfile are written to the binary log. If the database ever needs to be recovered, you can use the mysql command-line tool to load the data from the dump file and binary logs.

### Enable Binary Logging
To enable binary logging, edit /opt/zimbra/conf/my.cnf and add the following lines:
`log-bin = <path>/<basename>`

If using ZCS 7.0 or later, there is an additional recommend configuration option, binlog-format, that was introduced in MySQL 5.1.1:
`binlog-format = MIXED`

After enabling, restart the service and MySQL:
`$ zmstorectl restart`

### Backup MySQL Database
```bash
$ su - zimbra
$ source ~/bin/zmshutil
$ zmsetvars
```
If using binary logging, the dump is run like the following:
```bahs
$ /opt/zimbra/mysql/bin/mysqldump --user=root --password=$mysql_root_password --socket=$mysql_socket \
  --all-databases --single-transaction --master-data --flush-logs > {dump-file}.sql
```
  
If not using binary logging, the dump is run like the following:
```bash
$ /opt/zimbra/mysql/bin/mysqldump --user=root --password=$mysql_root_password --socket=$mysql_socket \
  --all-databases --single-transaction --flush-logs > {dump-file}.sql
```

where {dump-file} is the path to the MySQL dump file. Just like the binary log files, be sure to put the dump file on a separate disk device from the MySQL database files.

### Recovery
Before attempting database recovery, make sure that the mail server is not running while you're performing the restore. Then determine the first binlog file that needs to be replayed by grepping the dump file:
```bash
$ grep "CHANGE MASTER" dump.sql | head -1
CHANGE MASTER TO MASTER_LOG_FILE='binlog.000006', MASTER_LOG_POS=106;
```

In this example, the first binlog after the database dump is binlog.000006. Yours will probably be different. Next, determine the last binlog file that needs to be replayed. We do this by finding the last binlog file that was written:
```bash
$ ls /opt/zimbra/binlog/binlog.0* | sort | tail -1
/opt/zimbra/binlog/binlog.000009
```

and come up with binlog.000009. Flush the logs so that the binlog gets rotated, and the restore operations get written to binlog.000010:
```bash
$ mysqladmin flush-logs
```

Now restore the database dump:
```bash
$ mysql --user=root --password=XXX < dump.sql
```

Once the dump is restored, replay the binlog files 6-9 to restore the latest changes:
```bash
$ /opt/zimbra/mysql/bin/mysqlbinlog /opt/zimbra/binlog/binlog.000006 | mysql --user=root --password=XXX
$ /opt/zimbra/mysql/bin/mysqlbinlog /opt/zimbra/binlog/binlog.000007 | mysql --user=root --password=XXX
$ /opt/zimbra/mysql/bin/mysqlbinlog /opt/zimbra/binlog/binlog.000008 | mysql --user=root --password=XXX
$ /opt/zimbra/mysql/bin/mysqlbinlog /opt/zimbra/binlog/binlog.000009 | mysql --user=root --password=XXX
```

If you are not using binary logs, you can simply do a mysql restore.
