const gulp = require('gulp');
const exec = require('child_process').exec;

gulp.task('updateDeps', () => exec('ncu -u').stdout.pipe(process.stdout));
