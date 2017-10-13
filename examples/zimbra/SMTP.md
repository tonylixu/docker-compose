###Add Additional SMTP POrt
The ZCS MTA can be configured to accept mail traffic on additional SMTP service
ports. This means more than one TCP port can be used to bind to the SMTP
daemon.

For ZCS servers listening on the default port of 25,
/opt/zimbra/postfix/conf/master.cf.in contains this line:
```bash
smtp      inet  n       -       n       -       -       smtpd
```

To add an additional listener port of 2525, insert the the following after the
above:
```bash
2525      inet  n       -       n       -       -       smtpd
```

Then, restart the MTA:
```bash
# su - zimbra
# zmmtactl stop
# zmmtactl start
```
