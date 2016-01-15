gulp         = require "gulp"

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
