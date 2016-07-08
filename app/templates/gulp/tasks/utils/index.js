(function() {
  var exec, exports, fs, path;

  exec = require('child_process').exec;

  fs = require('fs');

  path = require('path');

  exports = module.exports;

  exports.execCommand = function(cmd) {
    return exec(cmd, function(err, stdout, stderr) {
      console.log(stdout);
      console.log(stderr);
      if (err) {
        return console.log(err);
      }
    });
  };

  exports.getNewestFile = function(dir) {
    var files, newest;
    files = fs.readdirSync(dir);
    newest = files.reduce(function(prev, next) {
      var nextPath, prevPath;
      prevPath = path.join(dir, prev);
      nextPath = path.join(dir, next);
      if (fs.statSync(prevPath).ctime > fs.statSync(nextPath).ctime) {
        return prev;
      } else {
        return next;
      }
    });
    return newest;
  };

}).call(this);
