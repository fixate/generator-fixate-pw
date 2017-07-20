const gulp = require('gulp');
const gutil = require('gulp-util');
const moment = require('moment');
const path = require('path');
const utils = require('./utils');

// set database credentials in your environment e.g. with .env

const dbImportFromTo = function(fromEnv, toEnv, done) {
  const dbFromPath = path.resolve(__dirname, '../../database', fromEnv);
  const dbEnvPrefix = `${toEnv.toUpperCase()}_DB_`;
  const newestFile = path.resolve(dbFromPath, utils.getNewestFile(dbFromPath));

  const cmd = [
    `mysql --host=${process.env[`${dbEnvPrefix}HOST`]} --user=${process.env[
      `${dbEnvPrefix}USER`
    ]}`,
    `--password=${process.env[`${dbEnvPrefix}PASS`]}`,
    `${process.env[`${dbEnvPrefix}NAME`]}`,
    `< ${newestFile}`,
  ].join(' ');

  gutil.log(gutil.colors.green(`importing ${newestFile} into ${toEnv}`));

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

  gutil.log(
    gutil.colors.red(
      `dropping tables from ${process.env[
        `${dbEnvPrefix}NAME`
      ]} database in ${env} environment`
    )
  );

  return utils.execCommand(cmd, done);
};

const dbDump = function(env, done) {
  const envPath = env !== 'prod' ? 'dev' : env;
  const date = moment();
  const dbEnvPrefix = `${env.toUpperCase()}_DB_`;
  const cmd = [
    `mysqldump --host=${process.env[`${dbEnvPrefix}HOST`]}`,
    `--user=${process.env[`${dbEnvPrefix}USER`]}`,
    `--password=${process.env[`${dbEnvPrefix}PASS`]}`,
    `${process.env[`${dbEnvPrefix}NAME`]} > ./database/${envPath}/${date.format(
      'YYYY-MM-DD-HH-mm-ss'
    )}-${env}.sql`,
  ].join(' ');

  return utils.execCommand(cmd, done);
};

//*------------------------------------*\
//     $DB DUMPS
//*------------------------------------*/
gulp.task('db-dump:dev', done => dbDump('dev', done));

gulp.task('db-dump:remote', done => dbDump('remote', done));

gulp.task('db-dump:staging', done => dbDump('staging', done));

gulp.task('db-dump:prod', done => dbDump('prod', done));

//*------------------------------------*\
//     $DB DROP TABLES
//*------------------------------------*/
gulp.task('db-droptables:dev', done => dbDropTables('dev', done));

//*------------------------------------*\
//     $DB IMPORTS
//*------------------------------------*/
gulp.task('db-import:prodtodev', ['db-droptables:dev'], done =>
  dbImportFromTo('prod', 'dev', done)
);

gulp.task('db-import:devtodev', ['db-droptables:dev'], done =>
  dbImportFromTo('dev', 'dev', done)
);
