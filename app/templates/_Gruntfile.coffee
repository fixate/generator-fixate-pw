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
					ssh_host: "<%= pkg.domain.username %>@<%= pkg.domain.name %>"
					backup_to: '<%= pkg.path.db_backup %>/prod/<%= pvt.db_prod.name %>_<%= grunt.template.date("yyyymmdd-HHmmss") %>.sql'


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

			# sync down
			down:
				options:
					src: "<%= pkg.domain.username %>@<%= pkg.domain.name %>:public_html/"
					dest: "src"
					syncDestIgnoreExcl: true

			# staging dry-run down
			#
			# only sync files that have been uploaded
			stagingdowndry:
				options:
					args: ["--dry-run", "--verbose"]
					src: "<%= pkg.domain.username %>@<%= pkg.domain.name %>:public_html/staging.<%= pkg.domain.name %>/site/assets/files/"
					dest: "src/site/assets/files"
					syncDestIgnoreExcl: true

			# sync staging to local
			#
			# only sync files that have been uploaded
			stagingdown:
				options:
					src: "<%= pkg.domain.username %>@<%= pkg.domain.name %>:public_html/staging.<%= pkg.domain.name %>/site/assets/files/"
					dest: "src/site/assets/files"
					syncDestIgnoreExcl: true

			# dry-run sync to prod
			updry:
				options:
					args: ["--dry-run", "--verbose"]
					src: "src/"
					dest: "public_html"
					host: "<%= pkg.domain.username %>@<%= pkg.domain.name %>"

			# sync to pro
			up:
				options:
					src: "src/"
					dest: "public_html"
					host: "<%= pkg.domain.username %>@<%= pkg.domain.name %>"

			# dry-run deploy to staging
			stagingupdry:
				options:
					args: ["--dry-run", "--verbose"]
					src: "src/"
					dest: "public_html/staging.<%= pkg.domain.name %>"
					host: "<%= pkg.domain.username %>@<%= pkg.domain.name %>"

			# deploy local changes to staging
			stagingup:
				options:
					src: "src/"
					dest: "public_html/staging.<%= pkg.domain.name %>"
					host: "<%= pkg.domain.username %>@<%= pkg.domain.name %>"


	#*------------------------------------*\
	#   $TASKS
	#*------------------------------------*/
	grunt.registerTask('default', ['watch'])
	grunt.registerTask('optim', ['imageoptim', 'svgmin'])
	grunt.registerTask('build', ['uglify', 'sass:minify', 'optim'])
