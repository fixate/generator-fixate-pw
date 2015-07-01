var shell = require("shelljs/global"),
		exec = require("child_process").exec;

if (!test('-f', 'bower.json')) {
	if (!which('bower')) {
		echo('bower not installed');
		echo('run npm install -g bower && npm install');
		echo('aborting');
		exit(1);
	} else {
		echo('bower not initialiased... initialising');
		exec('bower init');
	}
} else {
	echo('bower.json is initialised');
}

if (test('-f', 'secrets-sample.json') && !test('-f', 'secrets.json')) {
	echo('creating your very own secrets');
	cp('secrets-sample.json', 'secrets.json');
	echo('secrets.json created');
} else {
	echo('secrets.json is ready');
}

if (!test('-L', 'styleguide/src/assets/toolkit/assets')) {
	echo('symlinking styleguide assets to site assets');
	cd('styleguide/src/assets/toolkit');
	ln('-s', '../../../../src/site/templates/assets', 'assets');
	echo('assets symlinked');
} else {
	echo('styleguide correctly symlinked to site assets');
}

