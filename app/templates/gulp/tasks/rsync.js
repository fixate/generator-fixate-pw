const gulp = require('gulp');
const fancyLog = require('fancy-log');
const colors = require('ansi-colors');
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

  fancyLog(colors.green(`Rsyncing from ${rsyncOpts.src} to ${rsyncOpts.dest}`));

  return rsync(rsyncOpts, function(error, stdout, stderr, cmd) {
    if (error) {
      fancyLog(colors.red(error));
    }
    fancyLog('Command: \n', cmd);
    fancyLog(stderr, stdout);
    return done();
  });
}

function prepareRsync(
  done,
  {configPropName, isToRemote = true, rsyncOpts = {}},
) {
  ['dest', 'src'].forEach(function(curr) {
    const {PROD_SSH_USERNAME, PROD_DOMAIN} = process.env;

    if (!PROD_SSH_USERNAME || !PROD_DOMAIN) {
      throw new Error('No ssh username or domain set in .env');
    }

    const remoteHost = `${PROD_SSH_USERNAME}@${PROD_DOMAIN}:`;
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
const rsyncProdDownDry = gulp.task('rsync:prod:down:dry', done =>
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
const rsyncProdUpDry = gulp.task('rsync:prod:up:dry', done =>
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
