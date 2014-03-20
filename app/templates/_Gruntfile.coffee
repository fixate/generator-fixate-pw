module.exports = (grunt) ->

	pkg = grunt.file.readJSON('package.json')
	pvt = grunt.file.readJSON('private.json') if grunt.file.exists('private.json')

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
		pvt: pvt,

		# Project configuration
		# ---------------------

		#*------------------------------------*\
		#   $CONTRIB-SASS
		#*------------------------------------*/
		sass:
			options:
				quiet: false,
				cacheLocation: '<%= pkg.path.scss %>/.sass-cache'
			dist:
				files:
					'<%= pkg.path.css %>/style.css': '<%= pkg.path.scss %>/style.scss'
			minify:
				options:
					style: 'compressed'
				files:
					'<%= pkg.path.css %>/style.min.css': '<%= pkg.path.scss %>/style.scss'


		#*------------------------------------*\
		#   $IMAGEOPTIM
		#*------------------------------------*/
		imageoptim:
			options:
				imageAlpha: true,
				# jpegMini: true,
				quitAfter: true
			files:
				['<%= pkg.path.img %>']


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
			styleSymlinks:
				command: [
					'cd styleguide/public'
					'ln -s ../../<%= pkg.path.assets %> assets'
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
			css:
				files: ['<%= pkg.path.scss %>/**/*.scss'],
				tasks: ['sass:dist']
			coffee:
				files: ['<%= pkg.path.coffee %>/**/*.coffee'],
				tasks: ['coffee:dist']


		#*------------------------------------*\
		#   $CONTRIB-UGLIFY
		#*------------------------------------*/
		uglify:
			target:
				files:
					'<%= pkg.path.js %>/main.min.js': '<%= pkg.path.js %>/main.js'


		#*------------------------------------*\
		#   $MYSQL-DUMP
		#*------------------------------------*/
		db_dump:
			local:
				options:
					title: "local db"
					database: "[local db]"
					user: "root"
					pass: "password"
					host: "localhost"
					backup_to: '<%= pkg.path.db_backup %>/dev/dev_<%= grunt.template.date("yyyymmdd-HHmmss") %>.sql'
			prod:
				options:
					title: "prod db"
					database: "<%= pvt.db_prod.name %>"
					user: "<%= pvt.db_prod.user %>"
					pass: "<%= pvt.db_prod.pass %>"
					host: "<%= pvt.db_prod.host %>"
					ssh_host: "<%= pvt.username %>@<%= pvt.domain %>"
					backup_to: '<%= pkg.path.db_backup %>/prod/<%= pvt.db_prod.name %>_<%= grunt.template.date("yyyymmdd-HHmmss") %>.sql'


		#*------------------------------------*\
		#   $RSYNC
		#*------------------------------------*/
		# rsync files to and from production
		rsync:
			options:
				args: ["--archive", "--itemize-changes", "--progress", "--compress"]
				exclude: [
					".git*",
					".DS_Store",
					"node_modules",
					".sass-cache",
					"*.scss",
					"style.css",
					"*.js.map",
					"*.coffee",
					"config-dev.php",
					"assets/cache",
					"assets/files",
					"assets/sessions",
					"assets/logs"
				]
				recursive: true

			# dry-run down
			downdry:
				options:
					args: ["--dry-run", "--verbose"]
					src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/"
					dest: "src"
					syncDestIgnoreExcl: true

			# sync down
			down:
				options:
					src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/"
					dest: "src"
					syncDestIgnoreExcl: true

			# staging dry-run down
			#
			# only sync files that have been uploaded
			stagingdowndry:
				options:
					args: ["--dry-run", "--verbose"]
					src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/staging.<%= pvt.domain %>/site/assets/files/"
					dest: "src/site/assets/files"
					syncDestIgnoreExcl: true

			# sync staging to local
			#
			# only sync files that have been uploaded
			stagingdown:
				options:
					src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/staging.<%= pvt.domain %>/site/assets/files/"
					dest: "src/site/assets/files"
					syncDestIgnoreExcl: true

			# dry-run sync to prod
			updry:
				options:
					args: ["--dry-run", "--verbose"]
					src: "src/"
					dest: "public_html"
					host: "<%= pvt.username %>@<%= pvt.domain %>"

			# sync to pro
			up:
				options:
					src: "src/"
					dest: "public_html"
					host: "<%= pvt.username %>@<%= pvt.domain %>"

			# dry-run deploy to staging
			stagingupdry:
				options:
					args: ["--dry-run", "--verbose"]
					exclude: [
						".git*",
						".DS_Store",
						"node_modules",
						"config-dev.php",
						".sass-cache",
						"*.scss",
						"style.css",
						"*.js.map",
						"*.coffee",
						"assets/cache",
						"assets/files",
						"assets/logs",
						"assets/sessions",
						"config.php",
						"robots.txt"
					]
					src: "src/"
					dest: "public_html/staging.<%= pvt.domain %>"
					host: "<%= pvt.username %>@<%= pvt.domain %>"

			# deploy local changes to staging
			stagingup:
				options:
					src: "src/"
					exclude: [
						".git*",
						".DS_STORE",
						"node_modules",
						"config-dev.php",
						".sass-cache",
						"*.scss",
						"style.css",
						"*.js.map",
						"*.coffee",
						"assets/cache",
						"assets/files",
						"assets/logs",
						"assets/sessions",
						"config.php",
						"robots.txt"
					]
					dest: "public_html/staging.<%= pvt.domain %>"
					host: "<%= pvt.username %>@<%= pvt.domain %>"


		#*------------------------------------*\
		#   $DEV UPDATE
		#*------------------------------------*/
		devUpdate:
			options:
				reportUpdated: false
				semver: true
				packages:
					devDependencies: true
					dependencies: false
				packageJson: null
			check:
				updateType: 'report'
			ask:
				options:
					updateType: 'prompt'
			up:
				options:
					updateType: 'force'


	#*------------------------------------*\
	#   $TASKS
	#*------------------------------------*/
	grunt.registerTask 'default', ['watch']
	grunt.registerTask 'optim', ['imageoptim', 'svgmin']
	grunt.registerTask 'build', ['uglify', 'sass:minify', 'optim']
	grunt.registerTask 'depcheck', ['devUpdate:check']
	grunt.registerTask 'depask', ['devUpdate:ask']
	grunt.registerTask 'depup', ['devUpdate:up']
