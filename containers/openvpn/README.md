### Setup Instructions
* Initialize the configuration files and certificates
```bash
docker-compose run --rm openvpn ovpn_genconfig -u udp://openvpn.lixu.ca
docker-compose run --rm openvpn ovpn_initpki nopass
```
* Fix ownership (depending on how to handle your backups, this may not be needed)
```bash
chown -R $(whoami): ./openvpn-data
```
* Start OpenVPN server process
```bash
docker-compose up -d openvpn
```
* You can access the container logs with
```bash
docker-compose logs -f
```
* Generate a client certificate
```bash
export CLIENTNAME="txu"
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
# If with passphrase
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
```
* Retrieve the client configuration with embedded certificates
```bash
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
```

### Revoke a client cert
```bash
# Keep the corresponding crt, key and req files.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME
# Remove the corresponding crt, key and req files.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME remove
```

### Debugging Tips
Create an environment variable with the name DEBUG and value of 1 to enable debug output (using "docker -e").
```bash
docker-compose run -e DEBUG=1 openvpn
```

### Reference
https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md