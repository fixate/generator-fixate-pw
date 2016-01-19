gulp        = require "gulp"
exec        = require "gulp-exec"

path = require('../gulpconfig').path





#*------------------------------------*\
#     $SCRIPTS
#*------------------------------------*/
gulp.task 'scripts', () ->
  gulp.src('')
    .pipe exec("jspm bundle-sfx #{path.dev.js}/main.js #{path.dev.js}/main.bundle.js", { continueOnError: true })
    .pipe exec.reporter({
      err: true,
      stderr: true,
      stdout: true
    })
    .pipe global.browserSync.reload({stream: true})





#*------------------------------------*\
#     $SCRIPTS VENDORS
#*------------------------------------*/
gulp.task 'scripts:vendors', () ->
  # gulp.src('')
  #   .pipe exec("jspm bundle-sfx #{path.dev.js}/vendor.js #{path.dev.js}/vendor.bundle.js")
  #   .pipe global.browserSync.reload({stream: true})

