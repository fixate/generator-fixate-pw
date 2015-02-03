#*-----------------------------------*\
#		$SETTINGS
#*-----------------------------------*/
pkg = require './package.json'

#*------------------------------------*\
#   $LOAD DEPENDENCIES
#*------------------------------------*/
gulp = require "gulp"
shell = require "gulp-shell"
bump = require "gulp-bump"

#*------------------------------------*\
#   $SHELL
#*------------------------------------*/
gulp.task 'shell', shell.task [
	"echo pkg version: " + pkg.version,
	'echo say \"hello world\"'
]

#*------------------------------------*\
#   $BUMP
#*------------------------------------*/
gulp.task 'bump:major', (ver) ->
	gulp.src 'package.json'
	.pipe bump({type: 'major'})
	.pipe gulp.dest './'

gulp.task 'bump:minor', (ver) ->
	gulp.src 'package.json'
	.pipe bump({type: 'minor'})
	.pipe gulp.dest './'

gulp.task 'bump:patch', (ver) ->
	gulp.src 'package.json'
	.pipe bump({type: 'patch'})
	.pipe gulp.dest './'

#*------------------------------------*\
#		$DEV DEPENDENCIES UPDATE
#*------------------------------------*/
# no gulp task found yet
