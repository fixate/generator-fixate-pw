const gulp = require('gulp');
const runSequence = require('run-sequence');

/*------------------------------------*\
     $BUILD
\*------------------------------------*/
gulp.task('build', done =>
  runSequence(
    'clean:build',
    'images:minify:svgpartials',
    'images:minify:inlinesvgicons',
    'rev:fonts',
    'rev:images',
    'favicons:generate',
    ['rev:replace'],
    done
  )
);
