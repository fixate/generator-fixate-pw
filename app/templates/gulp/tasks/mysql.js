const gulp = require('gulp');
const fancyLog = require('fancy-log');
const colors = require('ansi-colors');
const moment = require('moment');
const path = require('path');

const utils = require('./utils');

// set database credentials in .env

const getCnfFilePath = (env) => {
  const pathParts = [__dirname, '..', '..', 'database', 'cnf'];

  return `${path.resolve(...pathParts)}/.my.cnf.${env}`;
};

const getDbCredentials = (env) => {
  const envSuffixes = ['name', 'host', 'pass', 'user'];
  const credentials = envSuffixes.reduce((acc, suffix) => {
    const envVar =
      process.env[`MYSQL_${env.toUpperCase()}_${suffix.toUpperCase()}`];

    return {...acc, [suffix]: envVar};
  }, {});

  return credentials;
};

const dbImportFromTo = function(fromEnv, toEnv, done) {
  const dbFromPath = path.resolve(__dirname, '../../database', fromEnv);
  const newestFile = path.resolve(dbFromPath, utils.getNewestFile(dbFromPath));
  const {host, name} = getDbCredentials(toEnv);

  const cmd = [
    `mysql`,
    `--defaults-file=${getCnfFilePath(toEnv)}`,
    `--host=${host}`,
    `${name}`,
    `< ${newestFile}`,
  ].join(' ');

  fancyLog(
    colors.green(`Importing ${newestFile} into ${toEnv} db "${name}"...`),
  );

  return utils.execCommand(cmd, done, (code) => {
    if (code === 0) {
      fancyLog(
        colors.green(`Imported ${newestFile} into db ${toEnv} "${name}"`),
      );
    } else {
      fancyLog(
        colors.red(`Failed to import ${newestFile} into ${toEnv} db "${name}"`),
      );
    }
  });
};

const dbDropTables = function(env, done) {
  const {host, name} = getDbCredentials(env);

  const cmd = [
    `mysqldump`,
    `--defaults-file=${getCnfFilePath(env)}`,
    `--host=${host}`,
    `--add-drop-table --no-data ${name}`,
    '| grep ^DROP',
    `| mysql`,
    `--defaults-file=${getCnfFilePath(env)}`,
    `--host=${host}`,
    `${name}`,
  ].join(' ');

  fancyLog(
    colors.yellow(`[Warning] Dropping tables from ${env} db "${name}"...`),
  );

  return utils.execCommand(cmd, done, (code) => {
    if (code === 0) {
      fancyLog(colors.green(`Dropped ${env} db "${name}" tables`));
    } else {
      fancyLog(colors.red(`Failed to drop ${env} db "${name}" tables`));
    }
  });
};

const dbDump = function(env, done) {
  const date = moment();
  const {host, name} = getDbCredentials(env);
  const filename = `./database/${env}/${date.format(
    'YYYY-MM-DD-HH-mm-ss',
  )}-${env}.sql`;

  const cmd = [
    `mysqldump`,
    `--defaults-file=${getCnfFilePath(env)}`,
    `--host=${host}`,
    `${name} > ${filename}`,
  ].join(' ');

  return utils.execCommand(cmd, done, (code) => {
    if (code === 0) {
      fancyLog(colors.green(`Created db dump ${filename} for db "${name}"`));
    } else {
      fancyLog(colors.red(`Failed to dump ${env} db "${name}"`));
    }
  });
};

//*------------------------------------*\
//     $DB DUMPS
//*------------------------------------*/
const dbDumpDev = gulp.task('db-dump:dev', function dbDumpDev(done) {
  return dbDump('dev', done);
});

const dbDumpRemote = gulp.task('db-dump:remote', function dbDumpRemote(done) {
  return dbDump('remote', done);
});

const dbDumpStaging = gulp.task('db-dump:staging', function dbDumpStaging(
  done,
) {
  return dbDump('staging', done);
});

const dbDumpProd = gulp.task('db-dump:prod', function dbDumpProd(done) {
  return dbDump('prod', done);
});

//*------------------------------------*\
//     $DB DROP TABLES
//*------------------------------------*/
gulp.task('db-droptables:dev', function dbDropTablesDev(done) {
  return dbDropTables('dev', done);
});

//*------------------------------------*\
//     $DB IMPORTS
//*------------------------------------*/
const dbImportProdToDev = gulp.task(
  'db-import:prodtodev',
  gulp.series('db-droptables:dev', function(done) {
    return dbImportFromTo('prod', 'dev', done);
  }),
);

const dbImportDevToDev = gulp.task(
  'db-import:devtodev',
  gulp.series('db-droptables:dev', function importDevToDev(done) {
    return dbImportFromTo('dev', 'dev', done);
  }),
);

module.exports = {
  dbDumpDev,
  dbDumpProd,
  dbDumpRemote,
  dbDumpStaging,
  dbImportDevToDev,
  dbImportProdToDev,
};
