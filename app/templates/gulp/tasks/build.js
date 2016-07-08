(function() {
  var gulp, runSequence;

  gulp = require("gulp");

  runSequence = require("run-sequence");

  gulp.task('build', function() {
    return runSequence("clean:build", "rev:fonts", "rev:images", ["rev:replace", "minify:scripts:vendors"]);
  });

}).call(this);
