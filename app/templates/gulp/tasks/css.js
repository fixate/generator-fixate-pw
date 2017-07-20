const gulp = require('gulp');
const autoprefixer = require('autoprefixer');
const colorguard = require('colorguard');
const postcss = require('gulp-postcss');
const sass = require('gulp-sass');
const sourcemaps = require('gulp-sourcemaps');

const conf = require('../gulpconfig');

//*------------------------------------*\
//     $CSS
//*------------------------------------*/
gulp.task('css', () => {
  const postcssPlugins = [
    autoprefixer({browsers: ['last 2 versions']}),
    colorguard({allowEquivalentNotation: true}),
  ];

  return gulp
    .src([`${conf.path.dev.scss}/**/*.{scss,sass}`])
    .pipe(sourcemaps.init())
    .pipe(sass(conf.sass).on('error', sass.logError))
    .pipe(postcss(postcssPlugins))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(conf.path.dev.css));
});

//*------------------------------------*\
//     $CSS WATCH
//*------------------------------------*/
gulp.task('css:watch', ['css'], () => global.browserSync.reload('*.css'));
