gulp         = require "gulp"
gutil        = require "gulp-util"
extend       = require "extend"
rsync        = require("rsyncwrapper")

conf = require '../gulpconfig'
secret = require '../secrets'

processRsync = (done, rsyncOpts = {}) ->
  rsyncOpts = extend {
    port: conf.ssh.port
    ssh: true
    recursive: true
    compareMode: "checksum"
    args: ["--verbose"]
  }, rsyncOpts

  gutil.log "Rsyncing from #{rsyncOpts.src} to #{rsyncOpts.dest}"

  rsync rsyncOpts, (error, stdout, stderr, cmd) ->
    gutil.log error if error
    gutil.log cmd, stderr, stdout
    done()

prepareRsync = (done, prop, isToRemote = true, rsyncOpts = {}) ->
  ["dest", "src"].forEach (curr) ->
    remoteHost = "#{secret.username}@#{secret.domain}:"
    rsyncOpts[curr] = if rsyncOpts[curr] then rsyncOpts[curr] else conf.rsync[prop][curr]

    rsyncOpts[curr] = "#{remoteHost}#{rsyncOpts[curr]}" if isToRemote && curr == "dest"
    rsyncOpts[curr] = "#{remoteHost}#{rsyncOpts[curr]}" if !isToRemote && curr == "src"

  rsyncOpts.exclude = conf.rsync[prop].exclude || ""

  processRsync(done, rsyncOpts)





#*------------------------------------*\
#     $RSYNC DOWN DRY RUN
#*------------------------------------*/
gulp.task "rsync:downdry", (done) ->
  prepareRsync done, "down", false, dryRun: true





#*------------------------------------*\
#     $RSYNC DOWN
#*------------------------------------*/
# sync down
gulp.task "rsync:down", (done) ->
  prepareRsync done, "down", false





#*------------------------------------*\
#     $RSYNC TO PROD DRY RUN
#*------------------------------------*/
# dry-run sync to prod
gulp.task "rsync:updry", (done) ->
  prepareRsync done, "up", true, dryRun: true





#*------------------------------------*\
#     $RSYNC TO PROD
#*------------------------------------*/
gulp.task "rsync:up", (done) ->
  prepareRsync done, "up"
