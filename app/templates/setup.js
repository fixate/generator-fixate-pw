var shell = require('shelljs/global'),
  exec = require('child_process').exec;

if (test('-f', 'gulp/secrets-sample.js') && !test('-f', 'gulp/secrets.js')) {
  echo('creating your very own secrets');
  cp('gulp/secrets-sample.js', 'gulp/secrets.js');
  echo('secrets.js created');
} else {
  echo('secrets.js is ready');
}
