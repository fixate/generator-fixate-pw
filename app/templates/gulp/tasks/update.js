(function() {
  var exec, gulp;

  gulp = require("gulp");

  exec = require("child_process").exec;

  gulp.task('updateDeps', function() {
    return exec('ncu -u').stdout.pipe(process.stdout);
  });

}).call(this);
