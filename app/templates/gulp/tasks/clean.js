const gulp = require('gulp');
const del  = require('del');

const conf = require('../gulpconfig');





//*------------------------------------*\
//     CLEAN
//*------------------------------------*/
gulp.task('clean:build', done =>
  del([
    `${conf.path.prod.assets}/**/*`,
    `${conf.path.dev.assets}/rev-manifest.json`
  ], done)
);
