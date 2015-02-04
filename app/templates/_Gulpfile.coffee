gulp        = require "gulp"
coffee      = require "gulp-coffee"
concat      = require "gulp-concat"
exec        = require "gulp-exec"
minifyCSS   = require "gulp-minify-css"
plumber     = require "gulp-plumber"
rename      = require "gulp-rename"
sass        = require "gulp-sass"
uglify      = require "gulp-uglify"
gutil       = require "gulp-util"
watch       = require "gulp-watch"
shell       = require "gulp-shell"
browserSync = require "browser-sync"
reload      = browserSync.reload
imagemin    = require "gulp-imagemin"
pngquant    = require "imagemin-pngquant"

pkg = require './package.json'
conf = require './config.json'
try
	pvt = require './private.json'
catch err
	console.log err

#*------------------------------------*\
#   $CONTRIB-SASS
#*------------------------------------*/
gulp.task "sass", () ->
  gulp.src([conf.path.scss + "/style.scss"])
    .pipe plumber()
    .pipe sass({errLogToConsole: true})
    .pipe gulp.dest(conf.path.css)
    .pipe reload({stream: true})

#*------------------------------------*\
#   $PIXEL &
#		$VECTOR OPTIM
#		-https://www.npmjs.com/package/gulp-imagemin
#*------------------------------------*/
gulp.task 'imagemin', () ->
	return gulp.src(conf.path.img+'/*')
		.pipe imagemin {
			optimizationLevel: 3,
			progressive: true,
			interlaced: true,
			svgoPlugins: [
				{removeViewBox: false},
				{removeUselessStrokeAndFill: false },
				{ removeEmptyAttrs: false }
			],
			use: [pngquant()]
		}
		.pipe gulp.dest conf.path.img
# 	imageoptim:
# 		options:
# 			imageAlpha: true,
# 			# jpegMini: true,
# 			quitAfter: true
# 		files:
# 			['<%= conf.path.img %>']
# 	svgmin:
# 		options:
# 			plugins: [{
# 				removeViewBox: false
# 			}]
# 		dist:
# 			files: [{
# 				expand: true,
# 				cwd: '<%= conf.path.img %>',
# 				src: ['**/*.svg'],
# 				dest: '<%= conf.path.img %>'
# 			}]


#*------------------------------------*\
#   $SHELL
#*------------------------------------*/
gulp.task 'shell', shell.task [
	"cd styleguide/public",
	'ln -s ../../' + conf.path.assets + ' assets'
].join('&&')


#*------------------------------------*\
#   $CONTRIB-COFFEE
#*------------------------------------*/
gulp.task "coffee", () ->
	gulp.src [conf.path.coffee+"/**/*.coffee"]
		.pipe plumber()
		.pipe coffee({bare: true}).on('error', gutil.log)
		.pipe gulp.dest(conf.path.js)
		.pipe reload({stream: true})

# Until I figure a better way
gulp.task "bitter-coffee", () ->
	gulp.src([conf.path.coffee+"/**/*.coffee"])
		.pipe plumber()
		.pipe coffee({bare: true}).on('error', gutil.log)
		.pipe uglify()
		.pipe gulp.dest(conf.path.js)
		.pipe reload({stream: true})


#*------------------------------------*\
#   $CONTRIB-WATCH
#*------------------------------------*/
gulp.task "watch", () ->
  gulp.watch conf.path.scss + "/**/*.scss", ["sass"]
  gulp.watch conf.path.coffee + "/**/*.coffee", ["coffee", reload]


#*------------------------------------*\
#   $CONTRIB-UGLIFY
#*------------------------------------*/
# 	uglify:
# 		target:
# 			files:
# 				'<%= conf.path.js %>/main.min.js': '<%= conf.path.js %>/main.js'


#*------------------------------------*\
#   $MYSQL-DUMP
#*------------------------------------*/
# 	db_dump:
# 		local:
# 			options:
# 				title: "local db"
# 				database: "[local db]"
# 				user: "root"
# 				pass: "password"
# 				host: "localhost"
# 				backup_to: '<%= conf.path.db_backup %>/dev/dev_<%= grunt.template.date("yyyymmdd-HHmmss") %>.sql'
# 		prod:
# 			options:
# 				title: "prod db"
# 				database: "<%= pvt.db_prod.name %>"
# 				user: "<%= pvt.db_prod.user %>"
# 				pass: "<%= pvt.db_prod.pass %>"
# 				host: "<%= pvt.db_prod.host %>"
# 				ssh_host: "<%= pvt.username %>@<%= pvt.domain %>"
# 				backup_to: '<%= conf.path.db_backup %>/prod/<%= pvt.db_prod.name %>_<%= grunt.template.date("yyyymmdd-HHmmss") %>.sql'


#*------------------------------------*\
#   $RSYNC
#*------------------------------------*/
# rsync files to and from production
# 	rsync:
# 		options:
# 			args: ["--archive", "--itemize-changes", "--progress", "--compress"]
# 			exclude: [
# 				".git*",
# 				".DS_Store",
# 				"node_modules",
# 				".sass-cache",
# 				"*.scss",
# 				"*.css.map",
# 				"assets/css/style.css",
# 				"assets/js/main.js",
# 				"*.js.map",
# 				"*.coffee",
# 				"config-dev.php",
# 				"assets/cache",
# 				"assets/files",
# 				"assets/sessions",
# 				"assets/logs"
# 			]
# 			recursive: true

# 		# dry-run down
# 		downdry:
# 			options:
# 				args: ["--dry-run", "--verbose"]
# 				src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/"
# 				dest: "src"
# 				syncDestIgnoreExcl: true

# 		# sync down
# 		down:
# 			options:
# 				src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/"
# 				dest: "src"
# 				syncDestIgnoreExcl: true

# 		# staging dry-run down
# 		#
# 		# only sync files that have been uploaded
# 		stagingdowndry:
# 			options:
# 				args: ["--dry-run", "--verbose"]
# 				src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/staging.<%= pvt.domain %>/site/assets/files/"
# 				dest: "src/site/assets/files"
# 				syncDestIgnoreExcl: true

# 		# sync staging to local
# 		#
# 		# only sync files that have been uploaded
# 		stagingdown:
# 			options:
# 				src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/staging.<%= pvt.domain %>/site/assets/files/"
# 				dest: "src/site/assets/files"
# 				syncDestIgnoreExcl: true

# 		# dry-run sync to prod
# 		updry:
# 			options:
# 				args: ["--dry-run", "--verbose"]
# 				src: "src/"
# 				dest: "public_html"
# 				host: "<%= pvt.username %>@<%= pvt.domain %>"

# 		# sync to pro
# 		up:
# 			options:
# 				src: "src/"
# 				dest: "public_html"
# 				host: "<%= pvt.username %>@<%= pvt.domain %>"

# 		# dry-run deploy to staging
# 		stagingupdry:
# 			options:
# 				args: ["--dry-run", "--verbose"]
# 				exclude: [
# 					".git*",
# 					".DS_Store",
# 					"node_modules",
# 					"config-dev.php",
# 					".sass-cache",
# 					"*.scss",
# 					"*.css.map",
# 					"assets/css/style.css",
# 					"assets/js/main.js",
# 					"*.js.map",
# 					"*.coffee",
# 					"assets/cache",
# 					"assets/files",
# 					"assets/logs",
# 					"assets/sessions",
# 					"config.php",
# 					"robots.txt"
# 				]
# 				src: "src/"
# 				dest: "public_html/staging.<%= pvt.domain %>"
# 				host: "<%= pvt.username %>@<%= pvt.domain %>"

# 		# deploy local changes to staging
# 		stagingup:
# 			options:
# 				src: "src/"
# 				exclude: [
# 					".git*",
# 					".DS_STORE",
# 					"node_modules",
# 					"config-dev.php",
# 					".sass-cache",
# 					"*.scss",
# 					"*.css.map",
# 					"assets/css/style.css",
# 					"assets/js/main.js",
# 					"*.js.map",
# 					"*.coffee",
# 					"assets/cache",
# 					"assets/files",
# 					"assets/logs",
# 					"assets/sessions",
# 					"config.php",
# 					"robots.txt"
# 				]
# 				dest: "public_html/staging.<%= pvt.domain %>"
# 				host: "<%= pvt.username %>@<%= pvt.domain %>"


#*------------------------------------*\
#   $DEV UPDATE
#*------------------------------------*/
# 	devUpdate:
# 		options:
# 			reportUpdated: false
# 			semver: true
# 			packages:
# 				devDependencies: true
# 				dependencies: false
# 			packageJson: null
# 		check:
# 			updateType: 'report'
# 		ask:
# 			options:
# 				updateType: 'prompt'
# 		up:
# 			options:
# 				updateType: 'force'


# #*------------------------------------*\
# #   $TASKS
# #*------------------------------------*/
# grunt.registerTask 'default', ['watch']
# grunt.registerTask 'optim', ['imageoptim', 'svgmin']
# grunt.registerTask 'build', ['uglify', 'sass:minify', 'optim']
# grunt.registerTask 'depcheck', ['devUpdate:check']
# grunt.registerTask 'depask', ['devUpdate:ask']
# grunt.registerTask 'depup', ['devUpdate:up']


#*------------------------------------*\
#   $DEFAULT
#*------------------------------------*/
gulp.task 'default', ['watch']
