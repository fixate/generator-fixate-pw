gulp        = require "gulp"
exec        = require "gulp-exec"

path = require('../gulpconfig').path

bundleScripts = (filenames) ->
  filenames.forEach (filename) ->
    gulp.src('')
      .pipe exec(
        "jspm bundle-sfx #{path.dev.js}/#{filename}.js #{path.dev.js}/#{filename}.bundle.js",
        { continueOnError: true }
      )
      .pipe exec.reporter({
        err: true,
        stderr: true,
        stdout: true
      })





#*------------------------------------*\
#     $SCRIPTS
#*------------------------------------*/
gulp.task 'scripts', () ->
  bundleScripts(['main', 'map'])





#*------------------------------------*\
#     $SCRIPTS VENDORS
#*------------------------------------*/
gulp.task 'scripts:vendors', () ->
  # bundleScripts(['vendor'])

