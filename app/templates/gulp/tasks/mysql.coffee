gulp   = require 'gulp'
moment = require 'moment'
path   = require 'path'
utils  = require './utils'

# add database credentials to your secrets.coffee
secret = require '../secrets'

dbImportFromTo = (fromEnv, toEnv) ->
  dbFromPath = path.resolve(__dirname, '../../database', fromEnv)
  dbEnv = "db_#{toEnv}"
  newestFile = path.resolve(dbFromPath, utils.getNewestFile(dbFromPath))

  cmd = [
    "mysql --user=#{secret[dbEnv].user}"
    "--password=#{secret[dbEnv].pass}"
    "#{secret[dbEnv].name}"
    "< #{newestFile}"
  ].join(' ')

  utils.execCommand cmd

dbDropTables = (env) ->
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

  utils.execCommand cmd

dbDump = (env) ->
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

  utils.execCommand cmd





gulp.task 'db-dump:dev', () ->
  dbDump('dev')

gulp.task 'db-dump:prod', () ->
  dbDump('prod')

gulp.task 'db-droptables:dev', () ->
  dbDropTables('dev')

gulp.task 'db-import:prodtodev', ['db-droptables:dev'], () ->
  dbImportFromTo('prod', 'dev')

gulp.task 'db-import:devtodev', ['db-droptables:dev'], () ->
  dbImportFromTo('dev', 'dev')
