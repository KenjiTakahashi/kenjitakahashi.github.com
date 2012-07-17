---
layout: blog
title: Using passport with flatiron (or - strictly - union).
tags:
- javascript
- coffeescript
- union
- flatiron
- nodejs
- passport
---

So, few days ago I tried using [passport][passport] authenticating middleware with [flatiron][flatiron] framework and found out it doesn’t really want to come along.

It’s not really about [flatiron][flatiron], but about it’s middleware framework, called [union][union].

The main problem is, it doesn’t use standard `http.IncomingMessage` prototype, passing it’s own `union.RoutingStream` instead. Luckily for us, there’s a [#flatiron][fbranch] branch available with a quick hack to work around it. Also, according to the [#24 issue][24] there should be native support for different frameworks in passport, soon. So, first thing to do for now is to add following line to our `package.json`:

    "dependencies": {
        "passport": "git://github.com/jaredhanson/passport.git#flatiron"
    }

After `npm install` we should be able to create a simple authentication:

    app = flatiron.app
    LocalStrategy = require('passport-local').Strategy

    passport.use new LocalStrategy (email, password, done) ->
        # usual auth logic here

    app.use flatiron.plugins.http, before: [
        connect.cookieParser()
        connect.session secret: 'passport-flatiron'
        passport.initialize()
        passport.session()
    ]

    passport.serializeUser (user, done) ->
        done null, user

    passport.deserializeUser (obj, done) ->
        User.findOne email: obj, (err, user) -> # change to our db query
            done err, user

    routes =
        '/login':
            get: # render login form here
            post: ->
                res = @res
                passport.authenticate('local') @req, @res, -> res.emit 'next'

    app.router = new director.http.Router(routes)
    app.start 8080

But this will just tell us ‘Unauthorized’ or… ‘Not found’.

To make it useful let’s redirect the user on success/failure using passport’s standard options, `successRedirect` and `failureRedirect`: (Note: for other ways, see [this gist][gist] and **comments**)

    routes =
        '/login':
            post:
                res = @res
                passport.authenticate('local',
                     successRedirect: '/members', failureRedirect: '/login'
                ) @req, @res, -> res.emit 'next'

And it explodes:

    node_modules/mongoose/lib/utils.js:413
            throw err;
                  ^
    TypeError: Object [object Object] has no method 'redirect'
        at Context.module.exports.delegate.fail (node_modules/passport/lib/passport/middleware/authenticate.js:119:20)
        at Context.actions.fail (node_modules/passport/lib/passport/context/http/actions.js:35:22)
        at verified (node_modules/passport-local/lib/passport-local/strategy.js:81:30)
        at Promise.app.use.before.stylus.middleware.src (test1.coffee:87:16)
        at Promise.addBack (node_modules/mongoose/lib/promise.js:120:8)
        at Promise.EventEmitter.emit (events.js:88:17)
        at Promise.emit (node_modules/mongoose/lib/promise.js:59:38)
        at Promise.complete (node_modules/mongoose/lib/promise.js:70:20)
        at Query.findOne (node_modules/mongoose/lib/query.js:856:30)
        at exports.tick (node_modules/mongoose/lib/utils.js:408:16)

It turns out that [union][union] doesn’t provide `res.redirect` method :( (see [#34][34] and [#36][36] for references). The way to get around this is to hack `res.redirect` in manually:

    app = flatiron.app
    app.before.push (req, res) ->
        res.redirect = (path) ->
            res.writeHead 302, 'Location': path
            res.end()
        res.emit 'next'

This way [passport][passport] should be able to actually redirect the user to specified location.

[passport]: http://passportjs.org
[flatiron]: http://flatironjs.org
[union]: http://flatironjs.org/#middleware
[fbranch]: https://github.com/jaredhanson/passport/tree/flatiron
[24]: https://github.com/jaredhanson/passport/pull/24
[gist]: https://gist.github.com/2132062
[34]: https://github.com/flatiron/union/issues/34
[36]: https://github.com/flatiron/union/pull/36
