const gulp        = require('gulp');
const cssnano     = require('gulp-cssnano');
const exec        = require('gulp-exec');
const imagemin    = require('gulp-imagemin');
const pngquant    = require('imagemin-pngquant');
const regexRename = require('gulp-regex-rename');
const rev         = require('gulp-rev');
const uglify      = require('gulp-uglify');

const conf = require('../gulpconfig');





//*------------------------------------*\
//     $MINIFY CSS
//*------------------------------------*/
gulp.task('minify:css', ['css'], () =>
  gulp.src([`${conf.path.dev.css}/style.css`])
    .pipe(cssnano())
    .pipe(regexRename(/\.css/, '.min.css'))
    .pipe(gulp.dest(conf.path.prod.css))
);





//*------------------------------------*\
//     $MINIFY SCRIPTS
//*------------------------------------*/
gulp.task('minify:scripts', ['scripts'], function() {
  let files = [
    `${conf.path.dev.js}/main.bundle.js`,
    `${conf.path.dev.js}/map.bundle.js`,
  ];

  return gulp.src(files)
    .pipe(uglify())
    .pipe(regexRename(/\.js/, '.min.js'))
    .pipe(gulp.dest(conf.path.prod.js));
});





//*------------------------------------*\
//     $MINIFY SCRIPTS VENDORS
//*------------------------------------*/
gulp.task('minify:scripts:vendors', ['scripts:vendors'], function() {});
  // files = [
  //   "#{conf.path.dev.js}/vendor.bundle.js"
  // ]

  // gulp.src(files)
  //   .pipe uglify()
  //   .pipe regexRename(/\.js/, '.min.js')
  //   .pipe gulp.dest(conf.path.prod.js)







