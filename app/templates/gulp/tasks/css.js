(function() {
  var autoprefixer, conf, cssNano, gulp, rename, sass, sourcemaps;

  gulp = require("gulp");

  autoprefixer = require("gulp-autoprefixer");

  sass = require("gulp-sass");

  sourcemaps = require("gulp-sourcemaps");

  cssNano = require('gulp-cssnano');

  rename = require('gulp-rename');

  conf = require('../gulpconfig');

  gulp.task("css", function() {
    return gulp.src([conf.path.dev.scss + "/**/*.{scss,sass}"]).pipe(sourcemaps.init()).pipe(sass().on('error', sass.logError)).pipe(autoprefixer({
      browsers: ['last 2 versions', 'ie >= 10']
    })).pipe(cssNano()).pipe(rename({
      suffix: '.min'
    })).pipe(sourcemaps.write('./')).pipe(gulp.dest(conf.path.dev.css)).pipe(global.browserSync.stream({
      match: '**/*.css'
    }));
  });

  gulp.task("adminthemecss", function() {
    return gulp.src("src/wire/modules/AdminTheme/AdminThemeReno/styles/*.{scss,sass}").pipe(sass().on('error', sass.logError)).pipe(gulp.dest("src/wire/modules/AdminTheme/AdminThemeReno/styles")).pipe(global.browserSync.stream({
      match: '**/*.css'
    }));
  });

}).call(this);
