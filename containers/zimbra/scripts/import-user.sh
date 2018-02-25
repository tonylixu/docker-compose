for account in `cat /opt/zimbra/backup/users.list` ;
do
    echo “Processing ${account} …”
    /opt/zimbra/bin/zmmailbox -z -m $account postRestURL "/?fmt=tgz&resolve=modify" /opt/zimbra/backup/$account.tgz
done
