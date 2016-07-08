(function() {
  var dbDropTables, dbDump, dbImportFromTo, gulp, moment, path, secret, utils;
  gulp = require('gulp');
  moment = require('moment');
  path = require('path');
  utils = require('./utils');
  secret = require('../secrets');

  dbImportFromTo = function(fromEnv, toEnv) {
    var cmd, dbEnv, dbFromPath, newestFile;
    dbFromPath = path.resolve(__dirname, '../../database', fromEnv);
    dbEnv = "db_" + toEnv;
    newestFile = path.resolve(dbFromPath, utils.getNewestFile(dbFromPath));
    cmd = ["mysql --user=" + secret[dbEnv].user, "--password=" + secret[dbEnv].pass, "" + secret[dbEnv].name, "< " + newestFile].join(' ');
    return utils.execCommand(cmd);
  };

  dbDropTables = function(env) {
    var cmd, dbEnv;
    dbEnv = "db_" + env;
    cmd = ["mysqldump --host=" + secret[dbEnv].host, "--user=" + secret[dbEnv].user, "--password=" + secret[dbEnv].pass, "--add-drop-table --no-data " + secret[dbEnv].name, "| grep ^DROP", "| mysql --host=" + secret[dbEnv].host, "--user=" + secret[dbEnv].user, "--password=" + secret[dbEnv].pass, "" + secret[dbEnv].name].join(' ');
    return utils.execCommand(cmd);
  };

  dbDump = function(env) {
    var cmd, date, dbEnv;
    date = moment();
    dbEnv = "db_" + env;
    cmd = ["mysqldump --host=" + secret[dbEnv].host, "--user=" + secret[dbEnv].user, "--password=" + secret[dbEnv].pass, secret[dbEnv].name + " > ./database/" + env + "/" + dbEnv + "-" + (date.format('YYYY-MM-DD-HH-mm-ss')) + ".sql"].join(' ');
    return utils.execCommand(cmd);
  };

  gulp.task('db-dump:dev', function() {
    return dbDump('dev');
  });

  gulp.task('db-dump:prod', function() {
    return dbDump('prod');
  });

  gulp.task('db-droptables:dev', function() {
    return dbDropTables('dev');
  });

  gulp.task('db-import:prodtodev', ['db-droptables:dev'], function() {
    return dbImportFromTo('prod', 'dev');
  });

  gulp.task('db-import:devtodev', ['db-droptables:dev'], function() {
    return dbImportFromTo('dev', 'dev');
  });

}).call(this);
