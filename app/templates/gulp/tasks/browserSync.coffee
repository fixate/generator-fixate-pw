gulp         = require "gulp"

# add your vhost to secrets.coffee to allow for live reloading and css injection
secret = require '../secrets'

gulp.task 'browser-sync', () ->
  global.browserSync.init {
    proxy: secret.bsProxy
    injectchanges: true
    open: false
    # notify: false
    # tunnel: true
  }

gulp.task 'bs-reload', () ->
  global.browserSync.reload()
