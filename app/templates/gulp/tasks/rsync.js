(function() {
  var _rsyncDo, _rsyncPrepare, conf, extend, gulp, gutil, rsync, secret;

  gulp = require("gulp");

  extend = require("extend");

  rsync = require("rsyncwrapper");

  gutil = require("gulp-util");

  conf = require('../gulpconfig');

  secret = require('../secrets');

  _rsyncDo = function(rsyncOpts) {
    if (rsyncOpts == null) {
      rsyncOpts = {};
    }
    rsyncOpts = extend({
      port: conf.ssh.port,
      ssh: true,
      recursive: true,
      compareMode: "checksum",
      args: ["--verbose"]
    }, rsyncOpts);
    gutil.log("Rsyncing from " + rsyncOpts.src + " to " + rsyncOpts.dest);
    return rsync(rsyncOpts, function(error, stdout, stderr, cmd) {
      if (error) {
        gutil.log(error);
      }
      return gutil.log(cmd, stderr, stdout);
    });
  };

  _rsyncPrepare = function(prop, isToRemote, rsyncOpts) {
    if (isToRemote == null) {
      isToRemote = true;
    }
    if (rsyncOpts == null) {
      rsyncOpts = {};
    }
    ["dest", "src"].forEach(function(curr) {
      var remoteHost;
      remoteHost = secret.username + "@" + secret.domain + ":";
      rsyncOpts[curr] = rsyncOpts[curr] ? rsyncOpts[curr] : conf.rsync[prop][curr];
      if (isToRemote && curr === "dest") {
        rsyncOpts[curr] = "" + remoteHost + rsyncOpts[curr];
      }
      if (!isToRemote && curr === "src") {
        return rsyncOpts[curr] = "" + remoteHost + rsyncOpts[curr];
      }
    });
    rsyncOpts.exclude = conf.rsync[prop].exclude || "";
    return _rsyncDo(rsyncOpts);
  };

  gulp.task("rsync:downdry", function() {
    return _rsyncPrepare("down", false, {
      dryRun: true
    });
  });

  gulp.task("rsync:down", function() {
    return _rsyncPrepare("down", false);
  });

  gulp.task("rsync:updry", function() {
    return _rsyncPrepare("up", true, {
      dryRun: true
    });
  });

  gulp.task("rsync:up", function() {
    return _rsyncPrepare("up");
  });

}).call(this);
