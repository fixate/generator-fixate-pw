gulp         = require "gulp"
imagemin     = require 'gulp-imagemin'
pngquant     = require 'imagemin-pngquant'
rename       = require "gulp-rename"
rev          = require 'gulp-rev'

path = require('../gulpconfig').path




#*------------------------------------*\
#     $MINIFY CSS
#*------------------------------------*/
gulp.task "minify:css", ["sass"], () ->
  gulp.src(["#{path.dev.css}/style.css"])
    .pipe cssnano()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(path.prod.css)





#*------------------------------------*\
#     $MINIFY JS
#*------------------------------------*/
gulp.task "minify:js", ["js"], () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/main.bundle.js #{path.prod.js}/main.bundle.min.js --skip-source-maps --minify")





#*------------------------------------*\
#     $MINIFY JS VENDORS
#*------------------------------------*/
gulp.task "minify:js:vendors", ["js:vendors"], () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/vendor.bundle.js #{path.prod.js}/vendor.bundle.min.js --skip-source-maps --minify")




