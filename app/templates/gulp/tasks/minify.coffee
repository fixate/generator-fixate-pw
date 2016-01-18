gulp         = require "gulp"
cssnano      = require "gulp-cssnano"
rename       = require "gulp-rename"
exec         = require "gulp-exec"

path = require('../gulpconfig').path




#*------------------------------------*\
#     $MINIFY CSS
#*------------------------------------*/
gulp.task "minify:css", ["sass"], () ->
  gulp.src(["#{path.dev.css}/style.css"])
    .pipe cssnano()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(path.dev.css)





#*------------------------------------*\
#     $MINIFY JS
#*------------------------------------*/
gulp.task "minify:js", ["js"], () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/built.js #{path.prod.js}/built.min.js --skip-source-maps --minify")





#*------------------------------------*\
#     $MINIFY JS VENDORS
#*------------------------------------*/
gulp.task "minify:js:vendors", ["js:vendors"], () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/vendor.built.js #{path.prod.js}/vendor.built.min.js --skip-source-maps --minify")




