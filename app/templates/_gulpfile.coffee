# Gulp
gulp         = require "gulp"
coffee       = require "gulp-coffee"
concat       = require "gulp-concat"
exec         = require "gulp-exec"
minifyCSS    = require "gulp-minify-css"
plumber      = require "gulp-plumber"
rename       = require "gulp-rename"
sass         = require "gulp-sass"
uglifyJs     = require "gulp-uglify"
gutil        = require "gulp-util"
watch        = require "gulp-watch"
cache        = require "gulp-cache"
remember     = require "gulp-remember"
shell        = require "gulp-shell"
browserSync  = require "browser-sync"
reload       = browserSync.reload
imagemin     = require "gulp-imagemin"
pngquant     = require "imagemin-pngquant"
rsyncwrapper = require "rsyncwrapper"
rsync        = rsyncwrapper.rsync
cp           = require 'child_process'
spawn        = cp.spawn
rev          = require 'gulp-rev'
replace      = require 'gulp-replace'

# Extra
extend          = require "extend"

pkg    = require './package.json'
conf  = require './gulpconfig.json'
try
  pvt = require './private.json'
catch err
  console.log err













#*------------------------------------*\
#    $SASS
#*------------------------------------*/
gulp.task "sass", () ->
  gulp.src([conf.path.pvt.scss + "/style.scss"])
    .pipe plumber(conf.plumber)
    .pipe sass({errLogToConsole: true})
    .pipe gulp.dest(conf.path.pvt.css)
    .pipe reload({stream: true})


#*------------------------------------*\
#    $PIXEL &
#    $VECTOR OPTIM
#*------------------------------------*/
gulp.task 'imagemin', () ->
	files = ['jpg', 'jpeg', 'png', 'svg'].map (ext) ->
		"#{conf.path.pvt.img}/**/*.#{ext}"

	return gulp.src([files])
		.pipe cache(imagemin {
			optimizationLevel: 3,
			progressive: true,
			interlaced: true,
			svgoPlugins: [
				{ removeViewBox: false },
				{ removeUselessStrokeAndFill: false },
				{ removeEmptyAttrs: false }
			],
			use: [pngquant()]
		})
		.pipe rev()
		.pipe remember()
		.pipe gulp.dest conf.path.pub.img
		.pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
		.pipe gulp.dest('./')





#*------------------------------------*\
#    $AUTO RELOAD GULPFILE ON SAVE
#    noxoc.de/2014/06/25/reload-gulpfile-js-on-change/
#*------------------------------------*/
gulp.task "auto_reload", () ->
  process = undefined
  restart = () ->
    if process != undefined
      process.kill()
    process = spawn 'gulp', ['default'], {stdio: 'inherit'}

  gulp.watch 'gulpfile.coffee', restart
  restart()


#*-------------------------------------*\
# $BROWSER-SYNC
#*-------------------------------------*/
gulp.task 'browser-sync', ['sass', 'coffee'], () ->
  browserSync {
    proxy: pvt.localsite
  }


#*------------------------------------*\
#    $COFFEE
#*------------------------------------*/
gulp.task "coffee", () ->
  gulp.src [conf.path.pvt.coffee+"/**/*.coffee"]
    .pipe plumber(conf.plumber)
    .pipe cache(coffee({bare: true}).on('error', gutil.log))
    .pipe remember()
    .pipe gulp.dest(conf.path.pvt.js)
    .pipe reload({stream: true})
  return





#*------------------------------------*\
#    $WATCH
#*------------------------------------*/
gulp.task "watch", ["browser-sync"], () ->
  gulp.watch conf.path.pvt.scss + "/**/*.scss", ["sass"]
  gulp.watch conf.path.pvt.coffee + "/**/*.coffee", ["coffee", reload]
  # gulp.watch conf.path.pvt.fnt + "/**/*", ['font']
  # gulp.watch conf.path.pvt.img + "/**/*", ['imagemin']





#*------------------------------------*\
#    $UGLIFY
#*------------------------------------*/
gulp.task "uglify", () ->
  gulp.src [conf.path.pvt.js + "/main.js"]
  .pipe uglifyJs()
  .pipe rev()
  .pipe rename({suffix: '.min'})
  .pipe gulp.dest(conf.path.pub.js)
  .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
  .pipe gulp.dest('./')





#*------------------------------------*\
#    $SASS
#*------------------------------------*/
gulp.task "minify", () ->
  gulp.src(["#{conf.path.pvt.css}/style.css"])
    .pipe minifyCSS({keepSpecialComments: 0})
    .pipe rev()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(conf.path.pub.css)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#    $FONT REV
#*------------------------------------*/
gulp.task "font", () ->
	files = ['eot', 'woff', 'ttf', 'svg'].map (ext) ->
		"#{conf.path.pvt.img}/**/*.#{ext}"

	gulp.src(["#{conf.path.pvt.fnt}/**/*.#{exts[key]}"])
		.pipe cache(rev())
		.pipe remember()
		.pipe gulp.dest(conf.path.pub.fnt)
		.pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
		.pipe gulp.dest('./')


#*------------------------------------*\
#    $REV REPLACE
#    github.com/jamesknelson/gulp-rev-replace/issues/23
#*------------------------------------*/
gulp.task 'rev_replace', ["uglify", "minify", "font", "imagemin"], () ->
  manifest = require "./#{conf.path.pvt.assets}/rev-manifest.json"
  stream = gulp.src ["./#{conf.path.pub.css}/#{manifest['style.css']}"]

  Object.keys(manifest).reduce((stream, key) ->
    stream.pipe replace(key, manifest[key])
  , stream)
    .pipe gulp.dest("./#{conf.path.pub.css}")





#*------------------------------------*\
#    $MYSQL-DUMP
#*------------------------------------*/
gulp.task "db_dump:dev", shell.task [
  "mysqldump --host=#{pvt.db_dev.host}
  --user=#{pvt.db_dev.user}
  --password=#{pvt.db_dev.pass}
   #{pvt.db_dev.name} > ./database/dev/dev-db-#{new Date.now()}.sql"
]

gulp.task "db_dump:prod", shell.task [
  "mysqldump --host=#{pvt.db_prod.host}
  --user=#{pvt.db_prod.user}
  --password=#{pvt.db_prod.pass}
   #{pvt.db_prod.name} > ./database/prod/prod-db-#{new Date.now()}.sql"
]





#*------------------------------------*\
#    $RSYNC
#*------------------------------------*/
# rsync files to and from production

# dry-run down
gulp.task "rsync:downdry", () ->
  rsyncDown = {
    dest: conf.rsyncFolders.localFolder,
    src: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}"
  }
  opts = extend rsyncDown, conf.ssh, conf.rsyncOpts, conf.rsyncDry
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout


# sync down
gulp.task "rsync:down", () ->
  rsyncDown = {
    dest: conf.rsyncFolders.localFolder,
    src: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}"
  }
  opts = extend rsyncDown, conf.ssh, conf.rsyncOpts
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout


# staging dry-run down
gulp.task "rsync:staging-downdry", () ->
  rsyncDown = {
    dest: conf.rsyncFolders.localFolder,
    src: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}/staging"
  }
  opts = extend rsyncDown, conf.ssh, conf.rsyncOpts, conf.rsyncDry
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout


# sync staging to local
gulp.task "rsync:staging-down", () ->
  rsyncDown = {
    dest: conf.rsyncFolders.localFolder,
    src: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}/staging"
  }
  opts = extend rsyncDown, conf.ssh, conf.rsyncOpts
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout


# dry-run sync to prod
gulp.task "rsync:updry", () ->
  rsyncUp = {
    dest: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}"
    src: conf.rsyncFolders.localFolder,
  }
  opts = extend rsyncUp, conf.ssh, conf.rsyncOpts, conf.rsyncDry
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout


# sync to production
gulp.task 'rsync:up', () ->
  rsyncUp = {
    src: conf.rsyncFolders.localFolder,
    dest: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}"
  }
  opts = extend rsyncUp, conf.ssh, conf.rsyncOpts
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout

# dry-run deploy to staging
gulp.task "rsync:staging-updry", () ->
  rsyncUp = {
    dest: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}/staging"
    src: conf.rsyncFolders.localFolder,
  }
  opts = extend rsyncUp, conf.ssh, conf.rsyncOpts, conf.rsyncDry
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout


# deploy local changes to staging
gulp.task "rsync:staging-up", () ->
  rsyncUp = {
    dest: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}/staging"
    src: conf.rsyncFolders.localFolder,
  }
  opts = extend rsyncUp, conf.ssh, conf.rsyncOpts
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout





#*------------------------------------*\
#    $DEV UPDATE
#*------------------------------------*/
# No exsisting gulp task implemented





#*------------------------------------*\
#    $TASKS
#*------------------------------------*/
gulp.task 'default', ['watch']
gulp.task "build", ["uglify", "minify", "font", "imagemin", "rev_replace"]
