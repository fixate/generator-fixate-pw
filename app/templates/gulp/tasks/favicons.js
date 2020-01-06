const gulp = require('gulp');
const createFavicons = require('gulp-favicons');
const fancyLog = require('fancy-log');
const imagemin = require('gulp-imagemin');
const pngquant = require('imagemin-pngquant');

const conf = require('../gulpconfig');

//*------------------------------------*\
//     $FAVICONS
//*------------------------------------*/
const favicons = gulp.task('favicons:generate', done => {
  gulp
    .src('src/device-icon-template.png')
    .pipe(
      createFavicons({
        background: '#fff',
        display: 'browser',
        orientation: 'portrait',
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
          yandex: false,
        },
      }).on('error', fancyLog),
    )
    .pipe(
      imagemin({
        optimizationLevel: 3,
        progressive: true,
        interlaced: true,
        use: [pngquant()],
      }),
    )
    .pipe(gulp.dest('src'));

  return done();
});

module.exports = {favicons};
