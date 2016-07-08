(function() {
  var gulp, secret;

  gulp = require("gulp");

  secret = require('../secrets');

  gulp.task('browser-sync', function() {
    return global.browserSync.init({
      proxy: secret.browserSyncProxy,
      injectchanges: true,
      open: false,
      notify: false,
        ghostMode: {
            clicks: false,
            forms: true,
            scroll: false
        }

    });
  });

  gulp.task('bs-reload', function() {
    return global.browserSync.reload();
  });

}).call(this);
