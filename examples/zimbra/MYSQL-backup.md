### MySQL Backup and Restore
The Zimbra Data Store is a MySQL database that contains all the metadata
regarding the messages including tags, conversations, and pointers to where the
messages are stored in the file system.

Each account (mailbox) resides only on one server. Each Zimbra server has its
own stand alone data store containing data for the mailboxes on that server.

### The Zimbra data store contains:
** *Mailbox-account mapping: The primary identifier with the Zimbra database is
the mailbox ID, rather than a username or account name. The mailbox ID is only
unique within a single mailbox server. The data store maps the Zimbra mailbox
IDs to the user's OpenLDAP accounts.
    Each user's set of tag definitions, folders, and contacts, calendar
appointments, tasks notebooks, and filter rules.
    Information about each mail message, including whether it is read or
unread, and which tags are associated.
