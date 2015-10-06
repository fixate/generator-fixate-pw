#*-----------------------------------*\
#   $SETTINGS
#*-----------------------------------*/
pkg = require './package.json'





#*------------------------------------*\
#   $LOAD DEPENDENCIES
#*------------------------------------*/
gulp  = require "gulp"
shell = require "gulp-shell"
bump  = require "gulp-bump"
git   = require "gulp-git"





#*------------------------------------*\
#   $SHELL
#*------------------------------------*/
gulp.task 'shell', shell.task [
  "echo pkg version: " + pkg.version
]




#*------------------------------------*\
#   $BUMP
#*------------------------------------*/
gulp.task 'bump:major', (ver) ->
  gulp.src 'package.json'
    .pipe bump({type: 'major'})
    .pipe gulp.dest './'
    .pipe git.commit('bump version')

gulp.task 'bump:minor', (ver) ->
  gulp.src 'package.json'
    .pipe bump({type: 'minor'})
    .pipe gulp.dest './'
    .pipe git.commit('bump version')

gulp.task 'bump', (ver) ->
  gulp.src 'package.json'
    .pipe bump({type: 'patch'})
    .pipe gulp.dest './'
    .pipe git.commit('bump version')





#*------------------------------------*\
#   $DEV DEPENDENCIES UPDATE
#*------------------------------------*/
gulp.task 'update_deps', shell.task 'npm-check-updates -u'





#*------------------------------------*\
#   $DEFAULT
#*------------------------------------*/
gulp.task 'default', ['shell']
