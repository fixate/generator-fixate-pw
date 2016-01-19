gulp         = require "gulp"
moment       = require "moment"
exec         = require("child_process").exec

secret = require '../secrets'

dbDump = (env) ->
  date = moment()
  dbEnv = "db_#{env}"
  cmd = [
    "mysqldump --host=#{secret[dbEnv].host}"
    "--user=#{secret[dbEnv].user}"
    "--password=#{secret[dbEnv].pass}"
    "#{secret[dbEnv].name} > ./database/#{env}/#{dbEnv}-#{date.format('YYYY-MM-DD-HH-mm-ss')}.sql"
  ].join(' ')

  exec cmd, (err, stdout, stderr) ->
   console.log stdout
   console.log stdout
   console.log err






gulp.task "db-dump:dev", () ->
  dbDump('dev')

gulp.task "db-dump:prod", () ->
  dbDump('prod')


