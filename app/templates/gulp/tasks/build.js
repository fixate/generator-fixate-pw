const gulp = require('gulp');
const runSequence = require('run-sequence');





//*------------------------------------*\
//     $BUILD
//*------------------------------------*/
gulp.task('build', () =>
  runSequence(
    'clean:build',
    'images:minify:svgpartials',
    'images:minify:inlinesvgicons',
    'rev:fonts',
    'rev:images',
    ['rev:replace', 'minify:scripts:vendors']
  )
);
