const gulp     = require('gulp');
const favicons = require('gulp-favicons');
const gutil    = require('gulp-util');
const imagemin = require('gulp-imagemin');
const pngquant = require('imagemin-pngquant');

const conf= require('../gulpconfig');





//*------------------------------------*\
//     $FAVICONS
//*------------------------------------*/
gulp.task('favicons:generate', () =>
  gulp.src(`${conf.path.dev.app}/device-icon-template.png`)
    .pipe(favicons({
      background: "#fff",
      display: "browser",
      orientation: "portrait",
      logging: true,
      icons: {
        android: true,
        appleIcon: true,
        appleStartup: false,
        coast: false,
        favicons: false, // use x-icon editor for multilayered favicons
        firefox: true,
        opengraph: true,
        twitter: true,
        windows: true,
        yandex: false
      }
      }).on('error', gutil.log))
    .pipe(imagemin({
      optimizationLevel: 3,
      progressive: true,
      interlaced: true,
      use: [pngquant()]
    }))
    .pipe(gulp.dest(conf.path.dist.app))
);





//*------------------------------------*\
//     $FAVICONS COPY
//*------------------------------------*/
gulp.task('favicons:copy', ['favicons:generate'], (done) => {
  gulp.src(`${conf.path.dev.app}/favicon.ico`)
    .pipe(gulp.dest(conf.path.dist.app));
});
