(function() {
  var conf, gulp, imagemin, pngquant, rename, replace, rev, revReplace;

  gulp = require('gulp');

  imagemin = require('gulp-imagemin');

  pngquant = require('imagemin-pngquant');

  rename = require('gulp-rename');

  replace = require('gulp-replace');

  rev = require('gulp-rev');

  revReplace = require('gulp-rev-replace');

  conf = require('../gulpconfig');

  gulp.task('rev:css', ['minify:css'], function() {
    return gulp.src([conf.path.prod.css + "/style.min.css"]).pipe(rename('style.css')).pipe(rev()).pipe(rename({
      suffix: '.min'
    })).pipe(gulp.dest(conf.path.prod.css)).pipe(rev.manifest(conf.revManifest.path, conf.revManifest.opts)).pipe(gulp.dest('./'));
  });

  gulp.task('rev:scripts', ['minify:scripts'], function() {
    return gulp.src([conf.path.prod.js + "/main.bundle.min.js"]).pipe(rename('main.bundle.js')).pipe(rev()).pipe(rename({
      suffix: '.min'
    })).pipe(gulp.dest(conf.path.prod.js)).pipe(rev.manifest(conf.revManifest.path, conf.revManifest.opts)).pipe(gulp.dest('./'));
  });

  gulp.task('rev:fonts', function() {
    var files;
    files = ['eot', 'woff', 'woff2', 'ttf', 'svg'].map(function(curr) {
      return conf.path.dev.fnt + "/**/*" + curr;
    });
    return gulp.src(files).pipe(rev()).pipe(gulp.dest(conf.path.prod.fnt)).pipe(rev.manifest(conf.revManifest.path, conf.revManifest.opts)).pipe(gulp.dest('./'));
  });

  gulp.task('rev:images', function() {
    return gulp.src(conf.path.dev.img + "/**/*.{jpg,jpeg,png,svg}").pipe(imagemin({
      optimizationLevel: 3,
      progressive: true,
      interlaced: true,
      svgoPlugins: [
        {
          removeViewBox: false
        }, {
          cleanupIDs: false
        }
      ],
      use: [pngquant()]
    })).pipe(rev()).pipe(gulp.dest(conf.path.prod.img)).pipe(rev.manifest(conf.revManifest.path, conf.revManifest.opts)).pipe(gulp.dest('./'));
  });

  gulp.task('rev:replace', ['rev:css', 'rev:scripts'], function() {
    var manifest;
    manifest = gulp.src("./" + conf.revManifest.path);
    return gulp.src([conf.path.prod.css + "/*.css", conf.path.prod.js + "/*.js"], {
      base: './'
    }).pipe(revReplace({
      manifest: manifest
    })).pipe(gulp.dest('./'));
  });

}).call(this);
