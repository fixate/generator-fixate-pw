gulp         = require 'gulp'
runSequence  = require 'run-sequence'





#*------------------------------------*\
#     $BUILD
#*------------------------------------*/
gulp.task 'build', () ->
  runSequence(
    'clean:build',
    'images:minify:svgpartials'
    'rev:fonts',
    'rev:images',
    ['rev:replace', 'minify:scripts:vendors']
  )
