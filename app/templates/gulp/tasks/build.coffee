gulp         = require "gulp"
runSequence  = require "run-sequence"

gulp.task 'build', () ->
  runSequence "clean:build", "rev:fonts", "rev:images", ["rev:replace", "minify:scripts:vendors"]
