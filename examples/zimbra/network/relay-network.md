###Modifying the relay networks
If you want to allow additional hosts or networks to send email through your
MTA, you add them to the allowed relay list. Be careful, misconfiguration of
this can allow malicious outsiders to send spam through your system.

###Getting the existing value
Run these commands on your MTA server:
```bash
$ su - zimbra
$ zmprov gs `zmhostname` | grep zimbraMtaMyNetworks
```

If nothing is returned, you're using the postfix default - fetch that with:
```bash
$ su - zimbra
$ postconf -d mynetworks
```

###Setting the new value
To add hosts, you'll need to add to the existing value you just fetched:
```
$ su - zimbra
$ zmprov ms `zmhostname` zimbraMtaMyNetworks "127.0.0.0/8 10.1.0.0/16 a.b.c.0/24
 w.x.y.z/32"

The quotes above are important.

When specifying an address range, it is important that the start of the address
range is used. Thus, 10.1.0.0/16 is valid (because the 10.1.0.0/16 address
block starts at 10.1.0.0). BUT, 10.1.128.0/16 is not (as it is not the start of
the block range 10.1.0.0 ~ 10.1.255.255).

###Restart the service
```bash
$ postfix reload
$ postconf mynetworks
```
