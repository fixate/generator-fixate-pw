gulp        = require "gulp"
exec        = require "gulp-exec"

path = require('../gulpconfig').path

#*------------------------------------*\
#     $JS
#*------------------------------------*/
gulp.task 'js', () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/main.js #{path.dev.js}/main.bundle.js")
    .pipe global.browserSync.reload({stream: true})





#*------------------------------------*\
#     $JS VENDORS
#*------------------------------------*/
gulp.task 'js:vendors', () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/vendor.js #{path.dev.js}/vendor.bundle.js")
    .pipe global.browserSync.reload({stream: true})
