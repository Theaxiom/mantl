Traefik
=======

.. versionadded:: 0.5

`Traefik <https://traefik.io/>`_ is a modern HTTP reverse proxy and load
balancer made to deploy microservices with ease. It supports several backends
(Docker, Mesos/Marathon, Consul, Etcd, Zookeeper, BoltDB, Rest API, file…) to
manage its configuration automatically and dynamically.

Traefik is used as the only work role on the edge nodes. You should customize
``traefik_marathon_domain`` to set a domain (for example
``apps.yourdomain.com``) and then set an A record for each of the edge servers
to ``*.apps.yourdomain.com``.

End to end ssl
----------------------
Traefik can proxy either http or https incoming traffic.  It can then forward traffic to backends as http or https.  If you have a secure backend and moderate security concernts you may pass everything to the backend as http and your life is easy.  If you need a secured backend for regulations or multitenancy concernts, you need end-to-end ssl and things get tricky.

Suppose you have a public facing app you want to be reached at myapp.example.com.  If you do not wish to have users accept an unverified cert, you will need to get a 3rd party verified cert. A common approach would be to pay a few hundred dollars to get a wildcard cert for *.example.com.  This is good for single-depth wildcards, so ``myapp.example.com`` and ``yourapp.example.com`` but not ``peter.app.example.com`` or ``jane.app.example.com``.

You can also get a cert from [http://letsencrypt.readthedocs.io/en/latest/using.html#standalone](letsencrypt).  If you all the apps you will be hosting already running, you can set them all as alternate names and get a single cert for all.
```
certbot certonly -n -d myapp.example.com -d yourapp.example.com
```
Letsencrypt tests each name (-d option) that you request the cert for, so each must have a routable DNS entry in some DNS provider like AWS or CloudFlare.
Then you would have to distribute the files to all the hosts running traefik.
For dynamic situations, until this is automated, a wildcard cert is much easier.

What about the backend?  In mantl, Traefik gets the names for backends from consul. The names given to servers end with .node.consul and these names cannot be supported by letsencrypt or Maybe you can change the defaut Consul DNS configuration: https://www.consul.io/docs/agent/options.html#_domain.  

From here on, we will assume you are running marathon and using a wildcard cert for traefik entrypoints and self-signed CA certs on the backends.  We will also assume you are name-flattening, so rather than naming things myapp.dev.client1.example.com and myapp.prod.client2.example.com you use myapp-dev-client1.example.com and myapp-prod-client2.example.com.
Your backend can either terminate ssl inside the container or have an nginx or kong ssl termination in front of it.

Let's follow the https traffic in both directions.
##### client -> traefik -> backend
Client ssl (browser.key, browser.cert - verified) → Traefik (entrypoint wildcard verified ssl, routed not decrypted) → ssl (verified) → Container (container.key, container.cert - self-signed CA)

traefik.protocol=https      # tells traefik to forward to https

##### backend -> traefik -> client
Backend ssl (container.key, container.cert - verified) → Traefik (entrypoint wildcard.key, wildcard.cert - verified ssl, decrypt backend payload) → ssl (verified, re-encrypt payload with wildcard creds) → ssl -> Browser (browser.key,browser.cert, decrypt)

### Verification of certs
At the moment, traefik does not support unverified certs for forwarded traffic to the backends.  Since the CA is self-signed, you need the traefik nodes to trust the ca.cert.pem file. (the name is arbitrary but should be pem format).
In mantl, the ca.cert.pem is at ssl/cacert.pem.  roles/common/ssl.yml copies that and the generates host.key.pem and host.cert.pem per host.
These cacert.pem and host.cert.pem are wildcarded for *.node.consul so you can use any name-flattend backend container with it.  If terminating ssl inside the container, you will need to mount host.cert.pem and host.cert.key into the container.  Some services also require the cert chain, which here would be
```
cat host.cert.pem cacert.pem >> ca-chain.cert.pem
```
Note that the order is important!  The signing cert (root of the cert chain goes at the bottom of the ca-chain.cert.pem file.

Now you must move the certs into place and run
```
update-ca-trust
```
or the equivalent.  Study ssl.yml or see http://kb.kerio.com/product/kerio-connect/server-configuration/ssl-certificates/adding-trusted-root-certificates-to-the-server-1605.html

Note that you must do the same inside the container at startup if you plan to do ssl termination inside the container.  A script like https://github.com/CognitiveScale-Solutions/docker-utils/blob/master/base_container_startup.sh 
could be added to your base container or to start.sh in 
``` 
CMD /start.sh
```
in your Dockerfile

Marathon traefik settings
----------------------
All available marathon settings are halfway down the page at
https://docs.traefik.io/toml/
Here we will show settings in a docker-compose.yml file and use a utility compose2marathon.py to generate the marathon files
```
myapp:
  image: somerepo/myapp
  labels:
   - traefik.protocol=https
   - traefik.frontend.passHostHeader=true
  volumes:
   - /host/path/to/certs:/container/path/to/certs
yourapp:
  image: somerepo/yourapp
  labels:
   - traefik.protocol=https
   - traefik.frontend.passHostHeader=true
  volumes:
   - /host/path/to/certs:/container/path/to/certs
 ```
compose2marathon dev-client1 takes the above compose file and generates files in dev-client1/marathon
Note that by default traefik writes names in the opposite order as consul.
compose2marathon corrects this via the following default additions.
   - traefik.frontend.rule=Host
   - traefik.frontend.value=marathonAppId-marathonGroupId


Migrating from haproxy
----------------------


Variables
---------

You can use these variables to customize your Traefik installation.

.. data:: traefik_marathon_endpoint

   The endpoint that Marathon talks to. Do not change this unless you are using
   non-default security settings (namely, if you have iptables disabled, this
   could also be set to ``http://marathon.service.consul:8080``)

   default: ``http://marathon.service.consul:18080``

.. data:: traefik_marathon_domain

   The domain that Traefik will match hosts on by default (you can `change this
   on a per-app basis
   <http://traefik.readthedocs.org/en/latest/backends/#marathon-backend>`_)
  
   default: ``marathon.localhost``
   Following the example above it would be ``example.com`` to mach the wildcard cert.
.. data:: traefik_marathon_expose_by_default

   Automatically expose Marathon applications in traefik.

   The traefik default is ``false``, or not forward traffic.
  
   The mantl default is set to ``true``.
 
