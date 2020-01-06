const gulp = require('gulp');
const fancyLog = require('fancy-log');
const colors = require('ansi-colors');
const moment = require('moment');
const path = require('path');

require('dotenv').config();

const utils = require('./utils');

// set database credentials in your environment e.g. with .env

const dbImportFromTo = function(fromEnv, toEnv, done) {
  const dbFromPath = path.resolve(__dirname, '../../database', fromEnv);
  const dbEnvPrefix = `${toEnv.toUpperCase()}_DB_`;
  const newestFile = path.resolve(dbFromPath, utils.getNewestFile(dbFromPath));

  const cmd = [
    `mysql --host=${process.env[`${dbEnvPrefix}HOST`]} --user=${
      process.env[`${dbEnvPrefix}USER`]
    }`,
    `--password=${process.env[`${dbEnvPrefix}PASS`]}`,
    `${process.env[`${dbEnvPrefix}NAME`]}`,
    `< ${newestFile}`,
  ].join(' ');

  fancyLog(colors.green(`importing ${newestFile} into ${toEnv}`));

  return utils.execCommand(cmd, done);
};

const dbDropTables = function(env, done) {
  const dbEnvPrefix = `${env.toUpperCase()}_DB_`;
  const cmd = [
    `mysqldump --host=${process.env[`${dbEnvPrefix}HOST`]}`,
    `--user=${process.env[`${dbEnvPrefix}USER`]}`,
    `--password=${process.env[`${dbEnvPrefix}PASS`]}`,
    `--add-drop-table --no-data ${process.env[`${dbEnvPrefix}NAME`]}`,
    '| grep ^DROP',
    `| mysql --host=${process.env[`${dbEnvPrefix}HOST`]}`,
    `--user=${process.env[`${dbEnvPrefix}USER`]}`,
    `--password=${process.env[`${dbEnvPrefix}PASS`]}`,
    `${process.env[`${dbEnvPrefix}NAME`]}`,
  ].join(' ');

  fancyLog(
    colors.red(
      `dropping tables from ${
        process.env[`${dbEnvPrefix}NAME`]
      } database in ${env} environment`,
    ),
  );

  return utils.execCommand(cmd, done);
};

const dbDump = function(env, done) {
  const date = moment();
  const dbEnvPrefix = `${env.toUpperCase()}_DB_`;
  const cmd = [
    `mysqldump --host=${process.env[`${dbEnvPrefix}HOST`]}`,
    `--user=${process.env[`${dbEnvPrefix}USER`]}`,
    `--password=${process.env[`${dbEnvPrefix}PASS`]}`,
    `${process.env[`${dbEnvPrefix}NAME`]} > ./database/${env}/${date.format(
      'YYYY-MM-DD-HH-mm-ss',
    )}-${env}.sql`,
  ].join(' ');

  return utils.execCommand(cmd, done);
};

//*------------------------------------*\
//     $DB DUMPS
//*------------------------------------*/
const dbDumpDev = gulp.task('db-dump:dev', done => dbDump('dev', done));

const dbDumpRemote = gulp.task('db-dump:remote', done =>
  dbDump('remote', done),
);

const dbDumpStaging = gulp.task('db-dump:staging', done =>
  dbDump('staging', done),
);

const dbDumpProd = gulp.task('db-dump:prod', done => dbDump('prod', done));

//*------------------------------------*\
//     $DB DROP TABLES
//*------------------------------------*/
gulp.task('db-droptables:dev', done => dbDropTables('dev', done));

//*------------------------------------*\
//     $DB IMPORTS
//*------------------------------------*/
const dbImportProdToDev = gulp.task(
  'db-import:prodtodev',
  gulp.series('db-droptables:dev', done => dbImportFromTo('prod', 'dev', done)),
);

const dbImportDevToDev = gulp.task(
  'db-import:devtodev',
  gulp.series('db-droptables:dev', done => dbImportFromTo('dev', 'dev', done)),
);

module.exports = {
  dbDumpDev,
  dbDumpProd,
  dbDumpRemote,
  dbDumpStaging,
  dbImportDevToDev,
  dbImportProdToDev,
};
