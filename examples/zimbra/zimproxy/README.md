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
