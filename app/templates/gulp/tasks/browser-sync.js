const gulp = require('gulp');

//*------------------------------------*\
//     BROWSER-SYNC
//*------------------------------------*/
const browserSync = gulp.task('browser-sync', done => {
  global.browserSync.init({
    proxy: 'localhost:8080',
    injectchanges: true,
    open: true,
    notify: false,
    // tunnel: true,
  });

  return done();
});

//*------------------------------------*\
//     BROWSER-SYNC RELOAD
//*------------------------------------*/
const bsReload = gulp.task('bs-reload', done => {
  global.browserSync.reload();
  done();
});

module.exports = {
  browserSync,
  bsReload,
};
