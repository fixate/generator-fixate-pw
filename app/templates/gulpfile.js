//*------------------------------------*\
//     $GULPFILE
//*------------------------------------*/
// All tasks are configured in ./gulp/tasks
//
// Simply add a new task there, and it will be automatically available as a gulp
// task for your project
const gulp = require('gulp');
const browserSync = require('browser-sync').create();

global.browserSync = browserSync;

require('./gulp/tasks/browser-sync');
require('./gulp/tasks/build');
require('./gulp/tasks/clean');
require('./gulp/tasks/css');
require('./gulp/tasks/favicons');
require('./gulp/tasks/images');
require('./gulp/tasks/mysql');
require('./gulp/tasks/rev');
require('./gulp/tasks/rsync');
require('./gulp/tasks/scripts');
require('./gulp/tasks/watch');

//*------------------------------------*\
//     $TASKS
//*------------------------------------*/
exports.default = gulp.task('default', gulp.series('watch', done => done()));
