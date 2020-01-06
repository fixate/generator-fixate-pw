const gulp = require('gulp');
const cssnano = require('gulp-cssnano');
const autoprefixer = require('autoprefixer');
const colorguard = require('colorguard');
const sass = require('gulp-sass');
const postcss = require('gulp-postcss');
const sourcemaps = require('gulp-sourcemaps');
const rename = require('gulp-rename');

const conf = require('../gulpconfig');

sass.compiler = require('sass');

/*------------------------------------*\
     $CSS
\*------------------------------------*/
const css = gulp.task('css', () => {
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

/*------------------------------------*\
     $MINIFY CSS
\*------------------------------------*/
const cssMinify = gulp.task(
  'css:minify',
  gulp.series('css', () => {
    return gulp
      .src(`${conf.path.dev.css}/style.css`)
      .pipe(cssnano())
      .pipe(rename({extname: '.min.css'}))
      .pipe(gulp.dest(conf.path.prod.css));
  }),
);

/*------------------------------------*\
     $WATCH CSS
\*------------------------------------*/
const cssWatch = gulp.task(
  'css:watch',
  gulp.series('css', done => {
    global.browserSync.reload('*.css');

    return done();
  }),
);

module.exports = {
  css,
  cssMinify,
  cssWatch,
};
