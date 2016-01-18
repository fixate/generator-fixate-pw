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
gulp.task "minify:js", () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/main.js #{path.prod.js}/built.min.js --skip-source-maps --minify")





#*------------------------------------*\
#     $MINIFY JS VENDORS
#*------------------------------------*/
gulp.task "minify:js:vendors", () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/vendor.js #{path.prod.js}/vendor.min.js --skip-source-maps --minify")




