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

if (test('-f', 'secrets-sample.coffee') && !test('-f', 'secrets.coffee')) {
  echo('creating your very own secrets');
  cp('secrets-sample.coffee', 'secrets.coffee');
  echo('secrets.coffee created');
} else {
  echo('secrets.coffee is ready');
}

if (!test('-L', 'styleguide/src/assets/toolkit/assets')) {
  echo('symlinking styleguide assets to site assets');
  cd('styleguide/src/assets/toolkit');
  ln('-s', '../../../../src/site/templates/assets', 'assets');
  echo('assets symlinked');
} else {
  echo('styleguide correctly symlinked to site assets');
}

