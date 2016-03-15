gulp        = require 'gulp'
cssnano     = require 'gulp-cssnano'
exec        = require 'gulp-exec'
imagemin    = require 'gulp-imagemin'
pngquant    = require 'imagemin-pngquant'
regexRename = require 'gulp-regex-rename'
rev         = require 'gulp-rev'
uglify      = require 'gulp-uglify'

conf = require('../gulpconfig')





#*------------------------------------*\
#     $MINIFY CSS
#*------------------------------------*/
gulp.task 'minify:css', ['css'], () ->
  gulp.src(["#{conf.path.dev.css}/style.css"])
    .pipe cssnano()
    .pipe regexRename(/\.css/, '.min.css')
    .pipe gulp.dest(conf.path.prod.css)





#*------------------------------------*\
#     $MINIFY SCRIPTS
#*------------------------------------*/
gulp.task 'minify:scripts', ['scripts'], () ->
  files = [
    "#{conf.path.dev.js}/main.bundle.js",
    "#{conf.path.dev.js}/map.bundle.js",
  ]

  gulp.src(files)
    .pipe uglify()
    .pipe regexRename(/\.js/, '.min.js')
    .pipe gulp.dest(conf.path.prod.js)





#*------------------------------------*\
#     $MINIFY SCRIPTS VENDORS
#*------------------------------------*/
gulp.task 'minify:scripts:vendors', ['scripts:vendors'], () ->
  # files = [
  #   "#{conf.path.dev.js}/vendor.bundle.js"
  # ]

  # gulp.src(files)
  #   .pipe uglify()
  #   .pipe regexRename(/\.js/, '.min.js')
  #   .pipe gulp.dest(conf.path.prod.js)






