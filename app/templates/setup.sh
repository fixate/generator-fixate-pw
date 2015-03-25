#!/bin/sh

# create a symlink from the styleguide to the production assets if one doesn't
# already exist
if ! [ -L styleguide/public/assets ]; then
	cd styleguide/public
	ln -s ../../src/site/templates/assets
	echo "assets symlinked"
else
	echo "assets already symlinked"
fi

# initialise bower if no bower.json exists
if ! [ -f bower.json ]; then
	echo "initialising bower"
	bower init
else
	echo "bower already initialised"
fi
