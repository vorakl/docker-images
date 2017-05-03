# The Pelican docker image based on Alpine

* [Tags](#tags)
* [Content](#content)
* [A simple start](#a-simple-start)
* [Examples](#examples)

## Tags

* **latest** is based on Vorakl's Alpine base image [vorakl/alpine:latest](https://hub.docker.com/r/vorakl/alpine/)

## Content

This image contains a pure installation of [Pelican](https://github.com/getpelican/pelican) plus a few well used plugins:

* markdown
* pelican-minify 
* pelican-youtube 
* beautifulsoup4

The idea behind is to have always a latest installation of Pelican (the image is built and tested automaticaly every day), without a need to install and update periodicaly all needed software for building static sites. Actually, virtual environments istead of installing to the system doesn't solve the main problem, because you still need to have an installed Python and keep Pelican up to date. The solution as simple as automate building of an image on daily bases using all latest packages with tests to be sure that a resulted image can run and build a site from templates. At the same time, this image doesn't bring other layers of complexity and doesn't limit in terms of ways to use it. The image contains only Python3, Pelican, few plugins and **does not** contain [Themes](https://github.com/getpelican/pelican-themes) and most [Plugins](https://github.com/getpelican/pelican-plugins). That means that to build a more or less real site you'll likely need to point Pelican to a some `theme` and to a directory with `plugins`. But as long as they both are represented as separate GitHub repos, themes and plugins are not a part of this Pelican docker image.

## A simple start

To get started you just need to have 

* a running Docker on a host 
* a theme
* plugins (optional)

Then, you'll need to mount all needed directories to the container and run Pelican with appropriate paramaters.
Let's say, I'm gonna test this solution in `/home/user/site/`. I've cloned the repo with [themes](https://github.com/getpelican/pelican-themes) to `/home/user/site/pelican-themes/` and I'm gonna use the `bootstrap` theme. The content of my future site is located in `/home/user/site/content/` and I'd like to have a rendered site in `/home/user/site/output/`. The last thing to mention is that the config file is `/home/user/site/pelicanconf.py`. In this case, the command I have to run will look like:

```bash
docker run \
    --rm \
    --user $(UID):$(GID) \
    --volume /home/user/site:/site \
    --volume /home/user/site/content:/input \
    --volume /home/user/site/output:/output \
    --volume /home/user/site/pelican-themes/bootstrap:/theme \
    vorakl/alpine-pelican \
        pelican /input -o /output -t /theme -s /site/pelicanconf.py
```

## Examples

You can take a look on how I'm using this docker image to build static sites in the [Makefile](https://github.com/vorakl/aves/blob/master/Makefile) (the `html` target) which comes with [Aves](https://github.com/vorakl/aves) theme.

Another example is the test of this image that can be found in the [Makefile](https://github.com/vorakl/docker-images/blob/master/Makefile) (the `test-alpine-pelican` target).
