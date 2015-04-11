var shell = require("shelljs/global"),
		execSync = require("execSync");

if (!test('-f', 'bower.json')) {
	if (!which('bower')) {
		echo('bower not installed');
		echo('run npm install -g bower && npm install');
		echo('aborting');
		exit(1);
	} else {
		echo('bower not initialiased... initialising');
		execSync.run('bower init');
	}
} else {
	echo('bower.json is initialised');
}

if (test('-f', 'secrets.json') && !test('-f', 'secrets.json')) {
	echo('creating your vey own secrets');
	cp('secrets-sample.json', 'secrets.json');
	echo('secrets.json created');
} else {
	echo('secrets.json is ready');
}

if (!test('-L', 'styleguide/public/assets')) {
	echo('symlinking styleguide assets to site assets');
	cd('styleguide/public');
	ln('-s', '../../src/site/templates/assets', 'assets');
	echo('assets symlinked');
} else {
	echo('styleguide correctly symlinked to site assets');
}

