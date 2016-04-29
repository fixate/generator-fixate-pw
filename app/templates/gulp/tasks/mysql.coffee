gulp   = require 'gulp'
gutil  = require 'gulp-util'
moment = require 'moment'
path   = require 'path'
utils  = require './utils'

# add database credentials to your secrets.coffee
secrets = require '../secrets'

dbImportFromTo = (fromEnv, toEnv, done) ->
  dbFromPath = path.resolve(__dirname, '../../database', fromEnv)
  dbEnv = "db_#{toEnv}"
  newestFile = path.resolve(dbFromPath, utils.getNewestFile(dbFromPath))
  secret = secrets[dbEnv]

  cmd = [
    "mysql --host=#{secret.host} --user=#{secrets[dbEnv].user}"
    "--password=#{secret.pass}"
    "#{secret.name}"
    "< #{newestFile}"
  ].join(' ')

  gutil.log gutil.colors.green("importing #{newestFile} into #{toEnv}")

  utils.execCommand cmd, done

dbDropTables = (env, done) ->
  dbEnv = "db_#{env}"
  secret = secrets[dbEnv]
  cmd = [
    "mysqldump --host=#{secret.host}"
    "--user=#{secret.user}"
    "--password=#{secret.pass}"
    "--add-drop-table --no-data #{secret.name}"
    "| grep ^DROP"
    "| mysql --host=#{secret.host}"
    "--user=#{secret.user}"
    "--password=#{secret.pass}"
    "#{secret.name}"
  ].join(' ')

  gutil.log gutil.colors.red(
    "dropping tables from #{secret.name} database in #{env} environment"
  )

  utils.execCommand cmd, done

dbDump = (env, done) ->
  path = if env != 'prod' then 'dev' else env
  date = moment()
  dbEnv = "db_#{env}"
  secret = secrets[dbEnv]
  cmd = [
    "mysqldump --host=#{secret.host}"
    "--user=#{secret.user}"
    "--password=#{secret.pass}"
    "#{secret.name} > ./database/#{path}/#{date.format('YYYY-MM-DD-HH-mm-ss')}-#{dbEnv}.sql"
  ].join(' ')

  utils.execCommand cmd, done





#*------------------------------------*\
#     $DB DUMPS
#*------------------------------------*/
gulp.task 'db-dump:dev', (done) ->
  dbDump('dev', done)

gulp.task 'db-dump:remote', (done) ->
  dbDump('remote', done)

gulp.task 'db-dump:staging', (done) ->
  dbDump('staging', done)

gulp.task 'db-dump:prod', (done) ->
  dbDump('prod', done)





#*------------------------------------*\
#     $DB DROP TABLES
#*------------------------------------*/
gulp.task 'db-droptables:dev', (done) ->
  dbDropTables('dev', done)





#*------------------------------------*\
#     $DB IMPORTS
#*------------------------------------*/
gulp.task 'db-import:prodtodev', ['db-droptables:dev'], (done) ->
  dbImportFromTo('prod', 'dev', done)

gulp.task 'db-import:devtodev', ['db-droptables:dev'], (done) ->
  dbImportFromTo('dev', 'dev', done)

