(function() {
  var cssnano, exec, gulp, imagemin, path, pngquant, rename, rev, uglify;

  gulp = require('gulp');
  cssnano = require('gulp-cssnano');
  exec = require('gulp-exec');
  imagemin = require('gulp-imagemin');
  pngquant = require('imagemin-pngquant');
  rename = require('gulp-rename');
  rev = require('gulp-rev');
  uglify = require('gulp-uglify');
  path = require('../gulpconfig').path;

  gulp.task('minify:css', ['css'], function() {
    return gulp.src([path.dev.css + "/*.css"]).pipe(cssnano({
      discardComments: {
        removeAll: true
      }
    })).pipe(rename({
      suffix: '.min'
    })).pipe(gulp.dest(path.prod.css));
  });

  gulp.task('minify:scripts', ['scripts'], function() {
    var files;
    files = [path.dev.js + "/*.js"];
    return gulp.src(files).pipe(uglify()).pipe(rename({
      suffix: '.min'
    })).pipe(gulp.dest(path.prod.js));
  });

  gulp.task('minify:scripts:vendors', ['scripts:vendors'], function() {});

}).call(this);
