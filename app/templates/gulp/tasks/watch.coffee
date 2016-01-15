gulp         = require "gulp"
watch        = require "gulp-watch"

conf = require '../gulpconfig'

gulp.task "watch", ["sass", "coffee", "browser-sync"], () ->
  global.isWatching = true

  gulp.watch "#{conf.path.dev.scss}/**/*.scss", ["sass"]
  gulp.watch "#{conf.path.dev.coffee}/**/*.coffee", ["concat", "bs-reload"]
  gulp.watch "#{conf.path.dev.views}/**/*.html.php", ["bs-reload"]
