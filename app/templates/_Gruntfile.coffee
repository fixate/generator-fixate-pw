module.exports = (grunt) ->

  pkg = grunt.file.readJSON('package.json')

  # Load dependancies
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

    # Coffee Lint
    coffeelint:
      gruntfile:
        src: 'gruntfile.coffee'
        options:
          max_line_length:
            level: 'ignore'

    # Manage Sass compilation
    sass:
      dist:
        options:
          quiet: false,
          cacheLocation: '<%= pkg.path.scss %>/.sass-cache'
        files:
          '<%= pkg.path.css %>/style.css': '<%= pkg.path.scss %>/style.scss'

    # Optimise images
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

    # Optimise SVG's
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

    # Execute shell commands
    shell:
      # Generate relative symlinks from styleguide to theme
      dist:
        command: [
          'say "hello"'
        ].join('&&'),
        options:
          stdout:true

		# Coffee script
		coffee:
			dist:
				files: [{
					expand: true
					cwd: '<%= pkg.path.coffee %>'
					src: '{,*/}*.coffee'
					dest: '<%= pkg.path.js %>'
					ext: '.js'
				}]

    # Watch configuration
    watch:
      gruntfile:
        files: 'Gruntfile.coffee',
        tasks: ['coffeelint']
      css:
        files: [
          '<%= pkg.path.scss %>/**/*.scss',
          '!<%= pkg.path.scss %>/docs/**/*.scss'
          ],
        tasks: ['sass']
			coffee:
				files: ['<%= pkg.path.coffee %>/{,*/}*.coffee'],
				tasks: ['coffee:dist']
      kss:
        files: [
          '<%= pkg.path.scss %>/docs/**/*.scss',
          'styleguide/template/**/*.*'
        ],
        tasks: ['kss']

    uglify:
      target:
        files:
          '<%= pkg.path.js %>/main.js'

  # Alias the `test` task to run the `mocha` task instead
  grunt.registerTask('default', ['watch'])
  grunt.registerTask('optim', ['imageoptim', 'svgmin'])
