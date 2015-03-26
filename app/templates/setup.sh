#!/bin/sh

# create a symlink from the styleguide to the production assets if one doesn't
# already exist
if ! [ -L styleguide/public/assets ]; then
	echo "assets not yet symlinked from styleguide -> symlinking"
	cd styleguide/public
	ln -s ../../src/site/templates/assets assets
fi

# add private.json if it doesn't yet exist
if [ -f private-sample.json ] && ! [ -f private.json ]; then
	echo "private.json not present -> making a copy using private-sample.json"
	cp private-sample.json private.json
fi

# initialise bower if no bower.json exists
if ! [ -f bower.json ]; then
	if ! type bower > /dev/null; then
		echo "you don't have bower installed"
		echo "run npm install bower -g && npm install"
		echo "aborting..."
		exit 1
	else
		echo "bower.json not present -> initialising bower"
		bower init
	fi
fi
