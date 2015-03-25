#!/bin/sh

# create a symlink from the styleguide to the production assets if one doesn't
# already exist
if ! [ -L styleguide/public/assets ]; then
	echo "assets not yet symlinked from styleguide - symlinking"
	cd styleguide/public
	ln -s ../../src/site/templates/assets
fi

# initialise bower if no bower.json exists
if ! [ -f bower.json ]; then
	echo "bower.json not present - initialising bower"
	bower init
fi

# add private.json if it doesn't yet exist
if ! [ -f private.json ]; then
	echo "private.json no present - copying private-sample.json"
	cp private-sample.json private.json
fi
