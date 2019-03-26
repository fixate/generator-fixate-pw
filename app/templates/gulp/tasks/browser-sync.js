const gulp = require('gulp');

// add your vhost to secrets.js to allow for live reloading and css injection
const secrets = require('../secrets');

//*------------------------------------*\
//     BROWSER-SYNC
//*------------------------------------*/
const browserSync = gulp.task('browser-sync', done => {
  global.browserSync.init({
    proxy: secrets.browserSyncProxy,
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
