const gulp = require('gulp');
const cssnano = require('gulp-cssnano');
const autoprefixer = require('autoprefixer');
const colorguard = require('colorguard');
const sass = require('gulp-sass');
const postcss = require('gulp-postcss');
const sourcemaps = require('gulp-sourcemaps');
const regexRename = require('gulp-regex-rename');

const conf = require('../gulpconfig');

/*------------------------------------*\
     $CSS
\*------------------------------------*/
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

/*------------------------------------*\
     $MINIFY CSS
\*------------------------------------*/
gulp.task('css:minify', ['css'], () =>
  gulp
    .src([`${conf.path.dev.css}/style.css`])
    .pipe(cssnano())
    .pipe(regexRename(/\.css/, '.min.css'))
    .pipe(gulp.dest(conf.path.prod.css))
);

/*------------------------------------*\
     $WATCH CSS
\*------------------------------------*/
gulp.task('css:watch', ['css'], () => global.browserSync.reload('*.css'));
