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

function prepareRsync(
  done,
  {configPropName, isToRemote = true, rsyncOpts = {}},
) {
  ['dest', 'src'].forEach(function(curr) {
    const remoteHost = `${process.env.PROD_SSH_USERNAME}@${
      process.env.PROD_DOMAIN
    }:`;
    rsyncOpts[curr] = rsyncOpts[curr]
      ? rsyncOpts[curr]
      : conf.rsync[configPropName][curr];

    if (isToRemote && curr === 'dest') {
      rsyncOpts[curr] = `${remoteHost}${rsyncOpts[curr]}`;
    }
    if (!isToRemote && curr === 'src') {
      return (rsyncOpts[curr] = `${remoteHost}${rsyncOpts[curr]}`);
    }
  });

  rsyncOpts.exclude = conf.rsync[configPropName].exclude || '';

  return processRsync(done, rsyncOpts);
}

//*------------------------------------*\
//     $RSYNC PROD DOWN DRY RUN
//*------------------------------------*/
const rsyncProdDownDry = gulp.task('rsync:prod:downdry', done =>
  prepareRsync(done, {
    configPropName: 'prodDown',
    isToRemote: false,
    rsyncOpts: {dryRun: true},
  }),
);

//*------------------------------------*\
//     $RSYNC PROD DOWN
//*------------------------------------*/
const rsyncProdDown = gulp.task('rsync:prod:down', done =>
  prepareRsync(done, {configPropName: 'prodDown', isToRemote: false}),
);

//*------------------------------------*\
//     $RSYNC TO PROD DRY RUN
//*------------------------------------*/
const rsyncProdUpDry = gulp.task('rsync:prod:updry', done =>
  prepareRsync(done, {
    configPropName: 'prodUp',
    isToRemote: true,
    rsyncOpts: {dryRun: true},
  }),
);

//*------------------------------------*\
//     $RSYNC TO PROD
//*------------------------------------*/
const rsyncProdUp = gulp.task('rsync:prod:up', done =>
  prepareRsync(done, {configPropName: 'prodUp'}),
);

module.exports = {
  rsyncProdDown,
  rsyncProdDownDry,
  rsyncProdUp,
  rsyncProdUpDry,
};
