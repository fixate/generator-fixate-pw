#*-----------------------------------*\
#		$SETTINGS
#*-----------------------------------*/
pkg = require './package.json'

#*------------------------------------*\
#   $LOAD DEPENDENCIES
#*------------------------------------*/
# $ = require('gulp-load-plugins')();
gulp = require "gulp"
shell = require "gulp-shell"
bump = require "gulp-bump"
depUpdate = require "gulp-depUpdate"
#*------------------------------------*\
#   $SHELL
#*------------------------------------*/
gulp.task 'shell', shell.task [
	'echo "pkg version: "{ + pkg.version}',
	'echo say \"hello world\"'
]

#*------------------------------------*\
#   $BUMP
#*------------------------------------*/
gulp.task 'bump', (ver) ->
	opts = {}
	if ver? opts = {version: ver}
	gulp.src 'package.json'
	.pipe bump(opts)
	.pipe gulp.dest './'

#*------------------------------------*\
#		$DEV DEPENDENCIES UPDATE
#*------------------------------------*/
# no gulp task found yet
