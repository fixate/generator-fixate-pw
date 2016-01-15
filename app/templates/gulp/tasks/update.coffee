gulp         = require "gulp"
shell        = require "gulp-shell"

gulp.task 'updateDeps', shell.task 'ncu -u'
