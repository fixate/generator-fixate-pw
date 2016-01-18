gulp         = require "gulp"
exec         = require("child_process").exec

gulp.task 'updateDeps', () -> exec('ncu -u').stdout.pipe(process.stdout)
