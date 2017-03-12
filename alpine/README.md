# Alpine base image 

## Tags

* **latest** based on the official [Alpine:latest](https://github.com/gliderlabs/docker-alpine/tree/rootfs/library-3.5/versions/library-3.5)

## Content 

They have everything is needed for...

* controling a life-cycle of processes inside a container and its behaviour ([TrivialRC](https://github.com/vorakl/TrivialRC))
* getting configuration from the environment and create a final view of configuration using a template engine ([FakeTpl](https://github.com/vorakl/FakeTpl))
* decrypting a downloaded configuration if it has sensitive data and resides on a public resource ([GnuPG](https://www.gnupg.org/))

Such aspects as monitoring, alerting, logging, usually, are done on higher levels (like OS and docker daemon)

