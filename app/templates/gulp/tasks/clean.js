(function() {
  var conf, del, gulp;

  gulp = require("gulp");

  del = require("del");

  conf = require('../gulpconfig');

  gulp.task('clean:build', function(done) {
    return del([conf.path.prod.assets + "/**/*", conf.path.dev.assets + "/rev-manifest.json"], done);
  });

}).call(this);
