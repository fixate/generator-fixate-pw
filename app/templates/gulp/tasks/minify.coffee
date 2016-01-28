gulp         = require 'gulp'
cssnano      = require 'gulp-cssnano'
exec         = require 'gulp-exec'
imagemin     = require 'gulp-imagemin'
pngquant     = require 'imagemin-pngquant'
rename       = require 'gulp-rename'
rev          = require 'gulp-rev'
uglify       = require 'gulp-uglify'

path = require('../gulpconfig').path




#*------------------------------------*\
#     $MINIFY CSS
#*------------------------------------*/
gulp.task 'minify:css', ['css'], () ->
  gulp.src(["#{path.dev.css}/style.css"])
    .pipe cssnano()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(path.prod.css)





#*------------------------------------*\
#     $MINIFY SCRIPTS
#*------------------------------------*/
gulp.task 'minify:scripts', ['scripts'], () ->
  files = [
    "#{path.dev.js}/main.bundle.js"
  ]

  gulp.src(files)
    .pipe uglify()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(path.prod.js)





#*------------------------------------*\
#     $MINIFY SCRIPTS VENDORS
#*------------------------------------*/
gulp.task 'minify:scripts:vendors', ['scripts:vendors'], () ->
  # files = [
  #   "#{path.dev.js}/vendor.bundle.js"
  # ]

  # gulp.src(files)
  #   .pipe uglify()
  #   .pipe rename({suffix: '.min'})
  #   .pipe gulp.dest(path.prod.js)





