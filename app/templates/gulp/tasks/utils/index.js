const {exec, spawn} = require('child_process');
const fs = require('fs');
const path = require('path');

const execCommand = (cmd, done, cb) => {
  const childProcess = exec(cmd);

  childProcess.stdout.on('data', data => {
    const msg = typeof data === 'string' ? data.trim() : data;
    console.log(`stdout:`, msg);
  });

  childProcess.stderr.on('data', data => {
    const msg = typeof data === 'string' ? data.trim() : data;
    console.log(`stderr:`, msg);
  });

  childProcess.on('exit', code => {
    if (typeof cb === 'function') {
      cb(code);
    }

    if (typeof done === 'function') {
      return done();
    } else {
      throw new Error(
        `execCommand requires Gulp's 'done' callback to signal the end of the stream`,
      );
    }
  });

  return childProcess;
};

const spawnCommand = (cmd, args, done, cb) => {
  const childProcess = spawn(cmd, args);

  childProcess.stdout.on('data', data => {
    console.log(`stdout:`, data);
  });

  childProcess.stderr.on('data', (...args) => {
    console.log(`stderr:`, ...args);
  });

  childProcess.on('exit', code => {
    if (typeof cb === 'function') {
      cb(code);
    }

    if (typeof done === 'function') {
      return done();
    } else {
      throw new Error(
        `spawnCommand requires Gulp's 'done' callback to signal the end of the stream`,
      );
    }
  });

  return childProcess;
};

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
  spawnCommand,
  getNewestFile,
};
