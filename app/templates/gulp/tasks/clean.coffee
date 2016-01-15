gulp         = require "gulp"
del          = require "del"

conf = require '../gulpconfig'

gulp.task 'clean:build', (done) ->
  del [
    "#{conf.path.prod.assets}/**/*",
    "#{conf.path.dev.assets}/rev-manifest.json"
  ], done
