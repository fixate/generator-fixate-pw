const gulp  = require('gulp');
const watch = require('gulp-watch');

const conf = require('../gulpconfig');





//*------------------------------------*\
//     $CSS WATCH
//*------------------------------------*/
gulp.task('watch', ['css:watch', 'images:watch', 'images:watch:svgpartials', 'scripts:watch', 'browser-sync'], function() {
  gulp.watch(`${conf.path.dev.scss}/**/*.scss`, ['css:watch']);
  gulp.watch([`${conf.path.dev.js}/**/!(*.bundle).js`, `${conf.path.dev.js}/**/*.jsx`], ['scripts:lint', 'scripts:watch']);
  gulp.watch(`${conf.path.dev.php}/**/*.php`, ['bs-reload']);
  gulp.watch(`${conf.path.dev.img}/raw/**/*.{jpeg,jpg,png,gif,svg,ico}`, ['images:watch']);
  gulp.watch(`${conf.path.dev.img}/raw/svg/inline-icons/*.svg`, ['images:watch:inlinesvgicons']);
  return gulp.watch(`${conf.path.dev.views}/partials/svg/raw/**/*.svg`, ['images:watch:svgpartials']);
});
