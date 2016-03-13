gulp         = require 'gulp'
runSequence  = require 'run-sequence'





#*------------------------------------*\
#     $BUILD
#*------------------------------------*/
gulp.task 'build', () ->
  runSequence(
    'clean:build',
    'images:svgminify'
    'rev:fonts',
    'rev:images',
    ['rev:replace', 'minify:scripts:vendors']
  )
