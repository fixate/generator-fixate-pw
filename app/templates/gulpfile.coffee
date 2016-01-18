#*------------------------------------*\
#     $GULPFILE
#*------------------------------------*/
# All tasks are configured in ./gulp/tasks
#
# Simply add a new task there, and it will be automatically available as a gulp
# task for your project
gulp         = require "gulp"
requireDir   = require "require-dir"
browserSync  = require("browser-sync").create()

global.isWatching = false
global.browserSync = browserSync

requireDir('./gulp', recurse: true)





#*------------------------------------*\
#     $TASKS
#*------------------------------------*/
gulp.task 'default', ['sass', 'watch']

coffee       = require "gulp-coffee"
concat       = require "gulp-concat"
exec         = require "gulp-exec"
gutil        = require "gulp-util"
imagemin     = require "gulp-imagemin"
minifyCSS    = require "gulp-minify-css"
plumber      = require "gulp-plumber"
rename       = require "gulp-rename"
replace      = require 'gulp-replace'
sass         = require "gulp-sass"
sourcemaps   = require "gulp-sourcemaps"

extend       = require "extend"
moment       = require "moment"
pngquant     = require "imagemin-pngquant"
runSequence  = require "run-sequence"
spawn        = cp.spawn





#*-------------------------------------*\
#      $BUILD
#*-------------------------------------*/
gulp.task 'build', () ->
  runSequence "clean:build", "rev:fonts", "rev:images", ["rev:replace", "minify:js:vendors"]





#*------------------------------------*\
#     $WATCH
#*------------------------------------*/





