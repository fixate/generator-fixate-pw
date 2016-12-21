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

if (!test('-L', 'styleguide/src/assets/toolkit/assets')) {
  echo('symlinking styleguide assets to site assets');
  cd('styleguide/src/assets/toolkit');
  ln('-s', '../../../../src/site/templates/assets', 'assets');
  echo('assets symlinked');
} else {
  echo('styleguide correctly symlinked to site assets');
}

if (!test('-f', 'styleguide/src/views/layouts/includes/inline-icons.svg.html')) {
  echo('creating empty inline icons partial for styleguide');
  touch('styleguide/src/views/layouts/includes/inline-icons.svg.html');
  echo('inline-icons.svg.html created');
} else {
  echo('inline-icons.svg.html ready');
}
