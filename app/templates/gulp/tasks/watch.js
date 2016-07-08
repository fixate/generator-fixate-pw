(function() {
  var conf, gulp, watch;

  gulp = require("gulp");

  watch = require("gulp-watch");

  conf = require('../gulpconfig');

  gulp.task("watch", ["css", "scripts", "svg", "browser-sync"], function() {
    global.isWatching = true;
    gulp.watch(conf.path.dev.scss + "/**/*.scss", ["css"]);
    gulp.watch(conf.path.dev.img + "/**/*.svg", ["svg"]);
    gulp.watch("src/wire/modules/AdminTheme/AdminThemeReno/styles/*.scss", ["adminthemecss"]);
    gulp.watch([conf.path.dev.js + "/*.js", conf.path.dev.js + "/**/*.jsx"], ["scripts", ["bs-reload"]]);
    return gulp.watch(conf.path.dev.views + "/**/*.{php,html,inc,twig,jade,tpl}", ["bs-reload"]);
  });

}).call(this);
