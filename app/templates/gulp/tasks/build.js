const gulp        = require('gulp');
const runSequence = require('run-sequence');





//*------------------------------------*\
//     $BUILD
//*------------------------------------*/
gulp.task('build', done =>
  runSequence(
    'clean:build',
    [
      'fonts:copy',
      'images:copy',
      'scripts:minify',
      'css:minify',
      'pug:minify',
      'favicons:copy',
    ],
    done
  )
);
