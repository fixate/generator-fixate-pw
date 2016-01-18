gulp         = require "gulp"
moment       = require "moment"
exec         = require("child_process").exec

secret = require '../secrets'




dbDump = (env) ->
  date = moment()
  dbEnv = "db_#{env}"

  exec [
      "mysqldump --host=#{secret[dbEnv].host},
      --user=#{secret[dbEnv].user},
      --password=#{secret[dbEnv].pass},
      #{secret[dbEnv].name} > ./database/#{env}/#{dbEnv}-#{date.format('YYYY-MM-DD-HH-mm-ss')}.sql"
    ].join(' '),
   (err, stdout, stderr) ->
     console.log stdout
     console.log stdout
     console.log err






gulp.task "db-dump:dev", () ->
  gulp.src('')
    .pipe dbDump('dev')

gulp.task "db-dump:prod", () ->
  gulp.src('')
    .pipe dbDump('prod')

