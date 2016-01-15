gulp         = require "gulp"
coffee       = require "gulp-coffee"
gutil        = require "gulp-util"
plumber      = require "gulp-plumber"

conf = require '../gulpconfig'

gulp.task "coffee", () ->
  gulp.src ["./#{conf.path.dev.coffee}/**/*.coffee"]
    .pipe plumber(conf.plumber)
    .pipe coffee({bare: true}).on('error', gutil.log)
    .pipe gulp.dest(conf.path.dev.js)
    .pipe global.browserSync.reload({stream: true})
