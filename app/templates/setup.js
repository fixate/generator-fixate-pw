var shell = require("shelljs");

var Setup = function() {
	var Setup = function() {
		this.setupBower();
		this.setupSecrets();
		this.setupSymlinks();
	}

	Setup.prototype.setupBower = function() {
		if (shell.test('-f', 'bower.json')) {
			if (!shell.which('bower')) {
				shell.echo('bower not installed');
				shell.echo('run npm install -g bower && npm install');
				shell.echo('aborting');
				shell.exit(1);
			} else {
				shell.echo('bower not initialiased... initialising');
				shell.exec('bower init');
			}
		}
	}

	Setup.prototype.setupSecrets = function() {
		if (test('-f', 'secrets.json') && !test('-f', 'secrets.json')) {
			shell.echo('creating your vey own secrets');
			shell.cp('secrets-sample.json', 'secrets.json');
			shell.echo('secrets.json created');
		}
	}

	Setup.prototype.setupSymlinks = function() {
		if (!test('-L', 'styleguide/public/assets')) {
			shell.exec('symlinking styleguide to assets');
			shell.cd('styleguide/public');
			shell.ln('-s', '../../src/site/templates/assets', 'assets');
			shell.exec('assets symlinked');
		}
	}

	return Setup;
}();

new Setup();
