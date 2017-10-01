# From http://linux-sys-adm.com/how-to-migrate-zimbra-678-and-next-version-with-script-from-one-server-to-another/
/opt/zimbra/bin/zmprov -l gaa > /opt/zimbra/backup/users.list
for account in `cat /opt/zimbra/backup/users.list` ;
do
echo “Processing ${account} …”
/opt/zimbra/bin/zmmailbox -z -m $account getRestURL ‘/?fmt=tgz’ > /opt/zimbra/backup/$account.tgz
done
