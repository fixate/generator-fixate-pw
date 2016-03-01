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
  cmd = [
    "mysqldump --host=#{secret[dbEnv].host}"
    "--user=#{secret[dbEnv].user}"
    "--password=#{secret[dbEnv].pass}"
    "--add-drop-table --no-data #{secret[dbEnv].name}"
    "| grep ^DROP"
    "| mysql --host=#{secret[dbEnv].host}"
    "--user=#{secret[dbEnv].user}"
    "--password=#{secret[dbEnv].pass}"
    "#{secret[dbEnv].name}"
  ].join(' ')

  utils.execCommand cmd

dbDump = (env) ->
  date = moment()
  dbEnv = "db_#{env}"
  cmd = [
    "mysqldump --host=#{secret[dbEnv].host}"
    "--user=#{secret[dbEnv].user}"
    "--password=#{secret[dbEnv].pass}"
    "#{secret[dbEnv].name} > ./database/#{env}/#{dbEnv}-#{date.format('YYYY-MM-DD-HH-mm-ss')}.sql"
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
