const gulp = require('gulp');
const gutil = require('gulp-util');
const extend = require('extend');
const rsync = require('rsyncwrapper');

const conf = require('../gulpconfig');

function processRsync(done, rsyncOpts = {}) {
  rsyncOpts = extend(
    {
      port: conf.ssh.port,
      ssh: true,
      recursive: true,
      compareMode: 'checksum',
      args: ['--verbose'],
    },
    rsyncOpts,
  );

  gutil.log(
    gutil.colors.green(`Rsyncing from ${rsyncOpts.src} to ${rsyncOpts.dest}`),
  );

  return rsync(rsyncOpts, function(error, stdout, stderr, cmd) {
    if (error) {
      gutil.log(gutil.colors.red(error));
    }
    gutil.log('Command: \n', cmd);
    gutil.log(stderr, stdout);
    return done();
  });
}

function prepareRsync(done, prop, isToRemote = true, rsyncOpts = {}) {
  ['dest', 'src'].forEach(function(curr) {
    const remoteHost = `${process.env.PROD_SSH_USERNAME}@${
      process.env.PROD_DOMAIN
    }:`;
    rsyncOpts[curr] = rsyncOpts[curr]
      ? rsyncOpts[curr]
      : conf.rsync[prop][curr];

    if (isToRemote && curr === 'dest') {
      rsyncOpts[curr] = `${remoteHost}${rsyncOpts[curr]}`;
    }
    if (!isToRemote && curr === 'src') {
      return (rsyncOpts[curr] = `${remoteHost}${rsyncOpts[curr]}`);
    }
  });

  rsyncOpts.exclude = conf.rsync[prop].exclude || '';

  return processRsync(done, rsyncOpts);
}

//*------------------------------------*\
//     $RSYNC DOWN DRY RUN
//*------------------------------------*/
const rsyncDownDry = gulp.task('rsync:downdry', done =>
  prepareRsync(done, 'down', false, {dryRun: true}),
);

//*------------------------------------*\
//     $RSYNC DOWN
//*------------------------------------*/
const rsyncDown = gulp.task('rsync:down', done =>
  prepareRsync(done, 'down', false),
);

//*------------------------------------*\
//     $RSYNC TO PROD DRY RUN
//*------------------------------------*/
const rsyncUpDry = gulp.task('rsync:updry', done =>
  prepareRsync(done, 'up', true, {dryRun: true}),
);

//*------------------------------------*\
//     $RSYNC TO PROD
//*------------------------------------*/
const rsyncUp = gulp.task('rsync:up', done => prepareRsync(done, 'up'));

module.exports = {
  rsyncDown,
  rsyncDownDry,
  rsyncUp,
  rsyncUpDry,
};
