# Gulp
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
rsync 			= require "gulp-rsync"

# Extra
extend 			= require "extend"

pkg = require './package.json'
conf = require './Gulpconfig.json'
try
	pvt = require './private.json'
catch err
	console.log err

#*------------------------------------*\
#   $CONF METHODS
#*------------------------------------*/

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
#		-In the grunt version this use to be
# 	seperated into svgmin and imageoptim
# 	-might want to implement sourcemap,
# 	still need to find out if it does what i think
#*------------------------------------*/
gulp.task 'imagemin', () ->
	return gulp.src(conf.path.img+'/*')
		.pipe imagemin {
			optimizationLevel: 3,
			progressive: true,
			interlaced: true,
			svgoPlugins: [
				{ removeViewBox: false },
				{ removeUselessStrokeAndFill: false },
				{ removeEmptyAttrs: false }
			],
			use: [pngquant()]
		}
		.pipe gulp.dest conf.path.img


#*------------------------------------*\
#   $SHELL
#*------------------------------------*/
gulp.task 'shell', shell.task [
	"cd styleguide/public",
	'ln -s ../../' + conf.path.assets + ' assets'
]


#*------------------------------------*\
#   $CONTRIB-COFFEE
#*------------------------------------*/
gulp.task "coffee", () ->
	gulp.src [conf.path.coffee+"/**/*.coffee"]
		.pipe plumber()
		.pipe coffee({bare: true}).on('error', gutil.log)
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
gulp.task "uglifyJs", () ->
	gulp.src [conf.path.js + "/main.js"]
	.pipe uglify()
	.pipe rename({suffix: '.min'})
	.pipe gulp.dest(conf.path.js)


#*------------------------------------*\
#   $CONTRIB-SASS
#*------------------------------------*/
gulp.task "minify", () ->
  gulp.src([conf.path.css + "/style.css"])
    .pipe minifyCSS({keepSpecialComments: 0})
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(conf.path.css)


#*------------------------------------*\
#   $MYSQL-DUMP
# 	http://dev.mysql.com/doc/refman/5.1/en/mysqldump.html
#*------------------------------------*/
gulp.task "db_dump:local", shell.task [
  'mysqldump --host=' + pvt.db_local.host + ' --user=' + pvt.db_local.user + ' --password=' + pvt.db_local.pass + ' ' + pvt.db_local.name + ' > ./database/local.sql'
]

gulp.task "db_dump:prod", shell.task [
  'mysqldump --host=' + pvt.db_prod.host + ' --user=' + pvt.db_prod.user + ' --password=' + pvt.db_prod.pass + ' ' + pvt.db_prod.name + ' > ./database/prod.sql'
]


#*------------------------------------*\
#   $RSYNC
#*------------------------------------*/
# rsync files to and from production
gulp.task 'rsync:up', () ->
  gulp.src '~dewald/ssh-test'
    .pipe rsync extend conf.rsyncOptions, { hostname: pvt.domain, username: pvt.username }

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

# dry-run down

# 		downdry:
# 			options:
# 				args: ["--dry-run", "--verbose"]
# 				src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/"
# 				dest: "src"
# 				syncDestIgnoreExcl: true

# sync down

# 		down:
# 			options:
# 				src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/"
# 				dest: "src"
# 				syncDestIgnoreExcl: true

# staging dry-run down

# 		#
# 		# only sync files that have been uploaded
# 		stagingdowndry:
# 			options:
# 				args: ["--dry-run", "--verbose"]
# 				src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/staging.<%= pvt.domain %>/site/assets/files/"
# 				dest: "src/site/assets/files"
# 				syncDestIgnoreExcl: true

# sync staging to local

# 		#
# 		# only sync files that have been uploaded
# 		stagingdown:
# 			options:
# 				src: "<%= pvt.username %>@<%= pvt.domain %>:public_html/staging.<%= pvt.domain %>/site/assets/files/"
# 				dest: "src/site/assets/files"
# 				syncDestIgnoreExcl: true

# dry-run sync to prod

# 		updry:
# 			options:
# 				args: ["--dry-run", "--verbose"]
# 				src: "src/"
# 				dest: "public_html"
# 				host: "<%= pvt.username %>@<%= pvt.domain %>"

# sync to pro

# 		up:
# 			options:
# 				src: "src/"
# 				dest: "public_html"
# 				host: "<%= pvt.username %>@<%= pvt.domain %>"

# dry-run deploy to staging

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

# deploy local changes to staging

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
# No exsisting gulp task runner

#*------------------------------------*\
#   $TASKS
#*------------------------------------*/
gulp.task 'default', ['watch']
gulp.task "build", ["uglifyJs", "minify"]
# grunt's devUpdate:check alternative
# grunt's devUpdate:ask alternative
# grunt's devUpdate:up alternative
