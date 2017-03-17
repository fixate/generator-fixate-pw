var shell = require("shelljs/global"),
    exec = require("child_process").exec;

if (!test('-f', 'bower.json')) {
  if (!which('bower')) {
    echo('bower module not installed');
    echo('run npm install -g bower && npm install');
    echo('aborting');
    exit(1);
  } else {
    echo('installing bower components');
    exec('bower install').stdout.pipe(process.stdout);
  }
} else {
  echo('bower.json is initialised');
}

if (test('-f', 'gulp/secrets-sample.js') && !test('-f', 'gulp/secrets.js')) {
  echo('creating your very own secrets');
  cp('gulp/secrets-sample.js', 'gulp/secrets.js');
  echo('secrets.js created');
} else {
  echo('secrets.js is ready');
}
