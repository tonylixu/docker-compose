### What is ZimProxy
Zimbra Proxy is an a high-performance proxy server that can be configured as a
HTTP[s]/POP[s]/IMAP[s] proxy used to reverse proxy HTTP[S]/POP[S]/IMAP[S]
client requests to a set of backend servers. It also provides functions like
GSSAPI authentication, throttle control, SSL connection with different
certificates for different virtual host names etc. In a typical use case,
Zimbra Proxy extract user login information and then fetches the route to the
upstream mail server or web server's address from "Nginx Lookup Extension", and
finally proxy the interactions between clients and upstream ZCS servers. To
accelerate the speed of the route lookup, memcached is introduced, which caches
the lookup result. There the subsequent logn with the same username will
directly be proxied without looking up in NLE.

### Benefits and Reasons to Use
1. Zimbra proxy centralizes access to Mailbox servers.
   * Zimbra Proxy allows mailbox servers to be hidden from public internet by
     acting as a reverse proxy & also allowing end users to access mail system
via single Login URL instead of knowing their mailbox hostnames. It acts as the
first entry point for all the HTTP[S]/POP[S]/IMAP[S] traffic and then
intelligently routes all kind of static UI requests (HTML/CSS/JS etc) and
Dynamic requests (SOAP/REST/IMAP/POP) to the appropriate upstream server.

2. Load Balancing
   * This is the reverse proxy function that people are not familiar with. Here
     the proxy routes incoming HTTP requests to a number of identical mail
servers. The upstream mail server selection can be based on a simple client IP
hash or round-robin algorithm. It's such a common function that load balancing
reverse proxies are usually just referred to as 'load balancers'.

3. Security
   * A reverse proxy can hide the topology and characteristics of your bacn-end
     servers by removing the need for direct internet access to them, you can
place your reverse proxy in an internet facing DMZ.

4. Authentication
   * You can use your reverse proxy to provide a single point of authentication
     for all HTTP requests.

5. SSL Termination
   * Here the reverse proxy handles incoming HTTPS connections, decrypting the
     requests and passing unencrypted requests on to the web servers.

6. Caching
   * Currently memcached module is used to achieve caching of upstream routes
     to mailstores on a per end-client basis. This significantly reduces the
route lookup time thereby improving the total time required to process the
request and boost performance.

7. Centralised Logging and Auditing
   * Because all HTTP requests are routed through the reverse proxy, it makes
     an excellent point for logging and auditing.

8. URL Rewriting
   * Sometimes the URL scheme that a legacy application presents is not ideal
     for discovery or search engine optimisation. A reverse proxy can rewrite
URLs before passing them on to your back-end servers.

### Components & Memcached
ZImbra Proxy is designed to provide a HTTP[S]/POP[S]/IMAP[S] reverse proxy that
is quick, reliable, and scalable. Zimbra Proxy includes the following:
* Nginx - A high performance HTTP[S]/POP[S]/IMAP[S] proxy server which handles
  all incoming HTTP[S]/POP[S]/IMAP[S] requests.
* Zimbra Proxy Route Lookup Handler - This servlet handles queries for the user
  account route information (the server and port number where user account
resides).

### Architecture and Flow
The following sequence explains the architecture and the login flow when an end
client connects to Zimbra Proxy.
1. End clients connect to Zimbra Proxy using HTTP[S]/POP[S]/IMAP[S] ports.
2. Proxy will attmpt to contact a memcached server if available and with
   caching enabled to query the upstream route information.
3. If the route info is present in memcached, then this will be a cache-hit and
   proxy connects to the corresponding Zimbra Mailbox server right away and
initiates a web/mail proxy session.The Memcached componet stores the route
information for the configured period of time. Zimbra proxy will use this route
info instead of quering the Zimbra Proxy Route Lookup Handler.
4. If the route information is not present in memcached, then this will be a
   cache-miss case, so Zimbra Proxy will proceed sending an HTTP request to an
available Zimbra Proxy Route Lookup Handler/NLE (elected by Round-Robin), to
look up the upstream mailbox server where this user account resides.
5. ZImbra Proxy Route Lookup Handler locates the route info from LDAP for the
   account being accessed and returns this back to Zimbra Proxy.
6. Zimbra Proxy uses this route information to connect to the corresponding
   Zimbra Mailbox server and initiates a web/mail proxy session. It will also
cache this route information into a memcached server so that the next time this
user logs in, the memcached server will have the upstream information available
in its cache, and so Zimbra Proxy will not need to contact NLE.The end client
is completely transparent to this and behaves as if it is connecting directly
to Zimbra Mailbox server.

### Proxy Ports
Zimbra Proxy Ports (External to ZCS)    Port
HTTP    80
HTTPS    443
POP3    110
POP3S (Secure POP3)    995
IMAP    143
IMAPS (Secure IMAP)    993
Proxy Admin console    9071
Zimbra Mailbox Ports (Internal to ZCS)    Port
Route Lookup Handler    7072
HTTP Backend (if Proxy configured)    8080
HTTPS Backend (if Proxy configured)    8443
POP3 Backend (if Proxy configured)    7110
POP3S Backend (if Proxy configured)    7995
IMAP Backend (if Proxy configured)    7143
IMAPS Backend (if Proxy configured)    7993
Mailbox Admin console    7071

### Proxy Configuration and Template files
The configuration is generated by `zmproxyconfgen` config generation script. It
reads in the proxy configuration template files, and generates the NGINX config
files after performing keyword substitution on the template files with values
from LDAP configuration.

zmproxyconfgen is usually never invoked directly -- it is invoked automatically
by zmproxyctl

### Config Files and Config Templates
To simplify configuration, the NGINX configuration files have been split up
into different config files based on functionality. The main, top-level
configuration file is `/opt/zimbra/conf/nginx.conf`, and this file includes the
main config, memcache config, mail config and web config files. The mail config
in turn includes the configuration for imap, imaps, pop3 and pop3s. The web
config includes the configuration for http and https. The template files follow
exactly the same inclusion hierarchy, and each configuration file has a
corresponding template file from which it is generated.

Each template file resides in `/opt/zimbra/conf/nginx/templates/`.

Each corresponding config file resides in `/opt/zimbra/conf/nginx/includes/`

Hierarchy:
```bash
/opt/zimbra/conf/nginx.conf
    |_ /opt/zimbra/conf/nginx/includes/nginx.conf.main
    |_ /opt/zimbra/conf/nginx/includes/nginx.conf.memcache
    |_ /opt/zimbra/conf/nginx/includes/nginx.conf.zmlookup
    |_ /opt/zimbra/conf/nginx/includes/nginx.conf.mail
       |_ /opt/zimbra/conf/nginx/includes/nginx.conf.mail.imap.default
       |_ /opt/zimbra/conf/nginx/includes/nginx.conf.mail.imaps.default
       |_ /opt/zimbra/conf/nginx/includes/nginx.conf.mail.pop3.default
       |_ /opt/zimbra/conf/nginx/includes/nginx.conf.mail.pop3s.default
    |_ /opt/zimbra/conf/nginx/includes/nginx.conf.web
       |_ /opt/zimbra/conf/nginx/includes/nginx.conf.web.http.default
       |_ /opt/zimbra/conf/nginx/includes/nginx.conf.web.https.default
       |_ /opt/zimbra/conf/nginx/includes/nginx.conf.web.admin.default
       |_ /opt/zimbra/conf/nginx/includes/nginx.conf.web.sso.default
```


Ref: [https://wiki.zimbra.com/wiki/Zimbra_Proxy_Guide | Zimbra Proxy]
