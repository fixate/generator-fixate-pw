const gulp = require('gulp');
const runSequence = require('run-sequence');

require('./clean');
require('./css');
require('./favicons');
require('./images');
require('./rev');
require('./scripts');

/*------------------------------------*\
     $BUILD
\*------------------------------------*/
const build = gulp.task(
  'build',
  gulp.series(
    'clean:build',
    gulp.parallel(
      'images:minify:svgpartials',
      'images:minify:inlinesvgicons',
      'rev:fonts',
      'rev:images',
      'favicons:generate',
    ),
    'rev:replace',
    done => done(),
  ),
);

module.exports = {build};
