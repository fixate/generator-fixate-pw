module.exports = (grunt) ->

<<<<<<< HEAD
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
          '<%= pkg.path.css %>/style.css': '<%= pkg.path.scss %>/style.scss'


    #*------------------------------------*\
    #   $IMAGEOPTIM
    #*------------------------------------*/
    imageoptim:
      options:
        imageAlpha: true,
        # jpegMini: true,
        quitAfter: true
      src:
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
=======
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
>>>>>>> 79cac2f8d6795e194071fe27736abdb6ab85787d
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
        exclude: [".git*", ".DS_STORE", "*.scss", "node_modules", "config-dev.php", "local-config.php", "debug-bar", ".sass-cache", "*.js.map", "sess_*", "logs/*", "cache/*"]
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
