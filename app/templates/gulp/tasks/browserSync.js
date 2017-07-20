const gulp = require('gulp');

// add your vhost to secrets.js to allow for live reloading and css injection
const secrets = require('../secrets');

//*------------------------------------*\
//     BROWSER-SYNC
//*------------------------------------*/
gulp.task('browser-sync', () =>
  global.browserSync.init({
    proxy: secrets.browserSyncProxy,
    injectchanges: true,
    open: false,
    // notify: false,
    // tunnel: true,
  })
);

//*------------------------------------*\
//     BROWSER-SYNC RELOAD
//*------------------------------------*/
gulp.task('bs-reload', () => global.browserSync.reload());
