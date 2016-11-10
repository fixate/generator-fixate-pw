const gulp   = require('gulp');
const gutil  = require('gulp-util');
const moment = require('moment');
const path   = require('path');
const utils  = require('./utils');

// add database credentials to your secrets.js
const secrets = require('../secrets');

const dbImportFromTo = function(fromEnv, toEnv, done) {
  const dbFromPath = path.resolve(__dirname, '../../database', fromEnv);
  const dbEnv = `db_${toEnv}`;
  const newestFile = path.resolve(dbFromPath, utils.getNewestFile(dbFromPath));
  const secret = secrets[dbEnv];

  const cmd = [
    `mysql --host=${secret.host} --user=${secrets[dbEnv].user}`,
    `--password=${secret.pass}`,
    `${secret.name}`,
    `< ${newestFile}`
  ].join(' ');

  gutil.log(gutil.colors.green(`importing ${newestFile} into ${toEnv}`));

  return utils.execCommand(cmd, done);
};

const dbDropTables = function(env, done) {
  const dbEnv = `db_${env}`;
  const secret = secrets[dbEnv];
  const cmd = [
    `mysqldump --host=${secret.host}`,
    `--user=${secret.user}`,
    `--password=${secret.pass}`,
    `--add-drop-table --no-data ${secret.name}`,
    "| grep ^DROP",
    `| mysql --host=${secret.host}`,
    `--user=${secret.user}`,
    `--password=${secret.pass}`,
    `${secret.name}`
  ].join(' ');

  gutil.log(gutil.colors.red(
    `dropping tables from ${secret.name} database in ${env} environment`
  ));

  return utils.execCommand(cmd, done);
};

const dbDump = function(env, done) {
  path = env !== 'prod' ? 'dev' : env;
  const date = moment();
  const dbEnv = `db_${env}`;
  const secret = secrets[dbEnv];
  const cmd = [
    `mysqldump --host=${secret.host}`,
    `--user=${secret.user}`,
    `--password=${secret.pass}`,
    `${secret.name} > ./database/${path}/${date.format('YYYY-MM-DD-HH-mm-ss')}-${dbEnv}.sql`
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
gulp.task('db-import:prodtodev', ['db-droptables:dev'], done => dbImportFromTo('prod', 'dev', done));

gulp.task('db-import:devtodev', ['db-droptables:dev'], done => dbImportFromTo('dev', 'dev', done));


