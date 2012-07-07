---
layout: blog
title: Deploying meteor application to jit.su.
tags:
- javascript
- meteor
- jit.su
---

Not so long ago I've stumbled upon [the meteor framework][meteor] for building websites using same Javascript API for both client and server.
I suddenly liked the approach and thought about basing the upgraded blog on this technology\*.

So I started looking for an node.js hosting, because meteor uses it server-side and I've found a nice one at [nodejitsu.com][jitsu] (or [jit.su][jitsu] for short).
While creating new apps is really simple, using their `jitsu` tool, deploying meteor app involves some more work to do.

The main "problem" here is that meteor creates a bundle, which locally includes everything, including external dependencies. While usually it should be no problem, jit.su seems to ignore local node_packages directories, thus refusing to work this way.

To resolve it, I've checked what meteor needs to run and extended the package.json file (which is the "core" of jit.su app including all necessary informations for the server) to make it aware if them. The extension is

    "dependencies": {
        "fibers": "0.6.x",
        "optimist": "0.3.x",
        "handlebars": "1.0.x",
        "mime": "1.2.x",
        "gzippo": "0.1.x",
        "useragent": "1.0.x",
        "connect": "2.3.x",
        "mime": "1.2.x",
        "sockjs": "0.3.x",
        "mongodb": "1.0.x",
    }

So the whole file will be something like this

    {
        "name": "<your_name>",
        "subdomain": "<choosen_subdomain>",
        "scripts": {
            "start": "main.js"
        },
        "version": "<snapshot_version>",
        "engines": {
            "node": "0.6.x"
        },
        "dependencies": {
            "fibers": "0.6.x",
            "optimist": "0.3.x",
            "handlebars": "1.0.x",
            "mime": "1.2.x",
            "gzippo": "0.1.x",
            "useragent": "1.0.x",
            "connect": "2.3.x",
            "mime": "1.2.x",
            "sockjs": "0.3.x",
            "mongodb": "1.0.x",
        }
    }

After this addition, deployment to jit.su should go smoothly and create a running meteor application.

The drawback of this method is that if you include any additional plugins (through `meteor add <package>`), you'll have to add appropriate node.js packages to the package.json, too. But for now, that's one (particularly easy) way to go.

\*I'm still not sure about that, as there are some other options to try before.

[meteor]: http://meteor.com
[jitsu]: http://nodejitsu.com
