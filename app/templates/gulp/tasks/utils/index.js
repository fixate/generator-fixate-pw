const exec = require('child_process').exec;
const fs = require('fs');
const path = require('path');

const execCommand = (cmd, done) =>
  exec(cmd, function(err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    if (err) {
      console.log(err);
    }
    if (done && typeof done === 'function') {
      return done();
    }
  });

const getNewestFile = function(dir) {
  const files = fs.readdirSync(dir);

  const newest = files.reduce(function(prev, next) {
    const prevPath = path.join(dir, prev);
    const nextPath = path.join(dir, next);

    if (fs.statSync(prevPath).ctime > fs.statSync(nextPath).ctime) {
      return prev;
    } else {
      return next;
    }
  });

  return newest;
};

module.exports = {
  execCommand,
  getNewestFile,
};
