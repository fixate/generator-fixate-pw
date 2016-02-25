gulp         = require "gulp"
extend       = require "extend"
rsync        = require "rsyncwrapper"
gutil        = require "gulp-util"

conf = require '../gulpconfig'
secret = require '../secrets'




_rsyncDo = (rsyncOpts = {}) ->
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

_rsyncPrepare = (prop, isToRemote = true, rsyncOpts = {}) ->
  ["dest", "src"].forEach (curr) ->
    remoteHost = "#{secret.username}@#{secret.domain}:"
    rsyncOpts[curr] = if rsyncOpts[curr] then rsyncOpts[curr] else conf.rsync[prop][curr]

    rsyncOpts[curr] = "#{remoteHost}#{rsyncOpts[curr]}" if isToRemote && curr == "dest"
    rsyncOpts[curr] = "#{remoteHost}#{rsyncOpts[curr]}" if !isToRemote && curr == "src"

  rsyncOpts.exclude = conf.rsync[prop].exclude || ""

  _rsyncDo(rsyncOpts)





# dry-run down
gulp.task "rsync:downdry", () ->
  _rsyncPrepare "down", false, dryRun: true

# sync down
gulp.task "rsync:down", () ->
  _rsyncPrepare "down", false

# dry-run sync to prod
gulp.task "rsync:updry", () ->
  _rsyncPrepare "up", true, dryRun: true

# sync to production
gulp.task "rsync:up", () ->
  _rsyncPrepare "up"
