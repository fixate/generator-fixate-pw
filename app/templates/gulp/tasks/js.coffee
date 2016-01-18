gulp        = require "gulp"
exec        = require "gulp-exec"

path = require('../gulpconfig').path

#*------------------------------------*\
#     $JS
#*------------------------------------*/
gulp.task 'js', () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/main.js #{path.prod.js}/built.js")
    .pipe global.browserSync.reload({stream: true})





#*------------------------------------*\
#     $JS VENDORS
#*------------------------------------*/
gulp.task 'js:vendors', () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/vendor.js #{path.prod.js}/vendor.built.js")
    .pipe global.browserSync.reload({stream: true})

