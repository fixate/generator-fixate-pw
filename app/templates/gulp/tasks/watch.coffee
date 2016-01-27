gulp         = require "gulp"
watch        = require "gulp-watch"

conf = require '../gulpconfig'

gulp.task "watch", ["css", "scripts", "browser-sync"], () ->
  global.isWatching = true

  gulp.watch "#{conf.path.dev.scss}/**/*.scss", ["css"]
  gulp.watch ["#{conf.path.dev.js}/**/!(*.bundle).js", "#{conf.path.dev.js}/**/*.jsx"], ["scripts:lint", "scripts"]
  gulp.watch "#{conf.path.dev.views}/**/*.html.php", ["bs-reload"]

