module.exports = (grunt) ->

	pkg = grunt.file.readJSON('package.json')

	#*------------------------------------*\
	#   $LOAD DEPENDENCIES
	#*------------------------------------*/
	dependencies = Object.keys(pkg.devDependencies).filter (o) ->
		/^grunt-.+/.test(o)

	for dep in dependencies
		grunt.loadNpmTasks(dep)

	#
	# Grunt configuration:
	#
	# https://github.com/cowboy/grunt/blob/master/docs/getting_started.md
	#
	grunt.initConfig
		pkg: pkg,

		# Project configuration
		# ---------------------

		#*------------------------------------*\
		#   $SHELL
		#*------------------------------------*/
		shell:
			dist:
				command: [
					'say "hello"'
				].join('&&'),
				options:
					stdout:true


		#*------------------------------------*\
		#   $BUMP
		#*------------------------------------*/
		bump:
			options:
				files: [
					'package.json'
				]
				commit: true
				commitMessage: 'bump version to %VERSION%'
				commitFiles: [
					'package.json'
				]
				createTag: false
				push: false



	#*------------------------------------*\
	#   $TASKS
	#*------------------------------------*/


