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
		#   $COFFEELINT
		#*------------------------------------*/
		coffeelint:
			gruntfile:
				src: 'gruntfile.coffee'
				options:
					max_line_length:
						level: 'ignore'


		#*------------------------------------*\
		#   $CONTRIB-SASS
		#*------------------------------------*/
		sass:
			dist:
				options:
					quiet: false,
					cacheLocation: '<%= pkg.path.scss %>/.sass-cache'
				files:
					'<%= pkg.path.css %>/style.css': '<%= pkg.path.scss %>/style.scss',
					'<%= pkg.path.styleguidecss %>/style.css': '<%= pkg.path.scss %>/style.scss'


		#*------------------------------------*\
		#   $IMAGEOPTIM
		#*------------------------------------*/
		imageoptim:
			files: [
				'<%= pkg.path.img %>'
			],
			options:
				# also run images through ImageAlpha.app before ImageOptim.app
				imageAlpha: true,
				# also run images through JPEGmini.app after ImageOptim.app
				# jpegMini: true,
				# quit all apps after optimisation
				quitAfter: true


		#*------------------------------------*\
		#   $SVGMIN
		#*------------------------------------*/
		svgmin:
			options:
				plugins: [{
					removeViewBox: false
				}]
			dist:
				files: [{
					expand: true,
					cwd: '<%= pkg.path.img %>',
					src: ['**/*.svg'],
					dest: '<%= pkg.path.img %>'
				}]


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
		#   $CONTRIB-COFFEE
		#*------------------------------------*/
		coffee:
			dist:
				files: [{
					expand: true
					cwd: '<%= pkg.path.coffee %>'
					src: '{,*/}*.coffee'
					dest: '<%= pkg.path.js %>'
					ext: '.js'
				}]


		#*------------------------------------*\
		#   $CONTRIB-WATCH
		#*------------------------------------*/
		watch:
			gruntfile:
				files: 'Gruntfile.coffee',
				tasks: ['coffeelint']
			css:
				files: [
					'<%= pkg.path.scss %>/{,*/}*.scss'
					],
				tasks: ['sass']
			coffee:
				files: ['<%= pkg.path.coffee %>/{,*/}*.coffee'],
				tasks: ['coffee:dist']


		#*------------------------------------*\
		#   $CONTRIB-UGLIFY
		#*------------------------------------*/
		uglify:
			target:
				files:
					'<%= pkg.path.js %>/main.min.js': '<%= pkg.path.js %>/main.js'


		#*------------------------------------*\
		#   $RSYNC
		#*------------------------------------*/
		# rsync files to and from production
		rsync:
			options:
				args: ["--archive", "--itemize-changes", "--progress", "--compress"]
				exclude: [".git*", ".DS_STORE", "*.scss", "node_modules", "config-dev.php", ".sass-cache", "*.js.map", "*.coffee"]
				recursive: true

			# dry-run down
			downdry:
				options:
					args: ["--dry-run", "--verbose"]
					src: "<%= pkg.domain.username %>@<%= pkg.domain.name %>:public_html/"
					dest: "src"
					syncDestIgnoreExcl: true

			# sync local with remote
			down:
				options:
					src: "<%= pkg.domain.username %>@<%= pkg.domain.name %>:public_html/"
					dest: "src"
					syncDestIgnoreExcl: true

			# dry-run up
			updrystaging:
				options:
					args: ["--dry-run", "--verbose"]
					src: "src/"
					dest: "public_html/staging.<%= pkg.domain.name %>"
					host: "<%= pkg.domain.username %>@<%= pkg.domain.name %>"

			# sync remote with local
			upstaging:
				options:
					src: "src/"
					dest: "public_html/staging.<%= pkg.domain.name %>"
					host: "<%= pkg.domain.username %>@<%= pkg.domain.name %>"

			# dry-run up
			updry:
				options:
					args: ["--dry-run", "--verbose"]
					src: "src/"
					dest: "public_html"
					host: "<%= pkg.domain.username %>@<%= pkg.domain.name %>"

			# sync remote with local
			up:
				options:
					src: "src/"
					dest: "public_html"
					host: "<%= pkg.domain.username %>@<%= pkg.domain.name %>"


	#*------------------------------------*\
	#   $TASKS
	#*------------------------------------*/
	grunt.registerTask('default', ['watch'])
	grunt.registerTask('optim', ['imageoptim', 'svgmin'])
