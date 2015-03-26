# Gulp
gulp         = require "gulp"
cache        = require "gulp-cache"
coffee       = require "gulp-coffee"
concat       = require "gulp-concat"
exec         = require "gulp-exec"
imagemin     = require "gulp-imagemin"
minifyCSS    = require "gulp-minify-css"
plumber      = require "gulp-plumber"
remember     = require "gulp-remember"
rename       = require "gulp-rename"
replace      = require 'gulp-replace'
rev          = require 'gulp-rev'
sass         = require "gulp-sass"
shell        = require "gulp-shell"
uglifyJs     = require "gulp-uglify"
gutil        = require "gulp-util"
watch        = require "gulp-watch"

browserSync  = require "browser-sync"
cp           = require "child_process"
moment			 = require "moment"
pngquant     = require "imagemin-pngquant"
reload       = browserSync.reload
rsyncwrapper = require "rsyncwrapper"
rsync        = rsyncwrapper.rsync
spawn        = cp.spawn

# Extra
extend = require "extend"

pkg    = require "./package.json"
conf   = require "./gulpconfig.json"
try
  pvt = require "./private.json"
catch err
  console.log err





#*-------------------------------------*\
# $BROWSER-SYNC
#*-------------------------------------*/
gulp.task 'browser-sync', () ->
  browserSync {
    proxy: pvt.bsProxy
  }






#*-------------------------------------*\
# $RELOAD
#*-------------------------------------*/
gulp.task 'bs-reload', () ->
  reload()





#*------------------------------------*\
#    $SASS
#*------------------------------------*/
gulp.task "sass", () ->
  gulp.src(["#{conf.path.pvt.scss}/style.scss"])
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





#*------------------------------------*\
#    $COFFEE
#*------------------------------------*/
gulp.task "coffee", () ->
  gulp.src ["#{conf.path.pvt.coffee}/**/*.coffee"]
    .pipe plumber(conf.plumber)
    .pipe cache(coffee({bare: true}).on('error', gutil.log))
    .pipe remember()
    .pipe gulp.dest(conf.path.pvt.js)
    .pipe reload({stream: true})
  return





#*------------------------------------*\
#    $WATCH
#*------------------------------------*/
gulp.task "watch", ["sass", "coffee", "browser-sync"], () ->
  gulp.watch "#{conf.path.pvt.scss}/**/*.scss", ["sass"]
  gulp.watch "#{conf.path.pvt.coffee}/**/*.coffee", ["coffee", "bs-reload"]
  gulp.watch "#{conf.path.pvt.php}/**/*.php", ["bs-reload"]
  gulp.watch "#{conf.path.pvt.views}/**/*.html.php", ["bs-reload"]





#*------------------------------------*\
#    $UGLIFY
#*------------------------------------*/
gulp.task "uglify", ["coffee"], () ->
  gulp.src ["#{conf.path.pvt.js}/main.js"]
  .pipe uglifyJs()
  .pipe rev()
  .pipe rename({suffix: '.min'})
  .pipe gulp.dest(conf.path.pub.js)
  .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
  .pipe gulp.dest('./')





#*------------------------------------*\
#    $MINIFY
#*------------------------------------*/
gulp.task "minify", ["sass"], () ->
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
db_dump = (env) ->
	date = moment()
	db_env = "db_#{env}"

	shell [
		"mysqldump --host=#{pvt[db_env].host}
			--user=#{pvt[db_env].user}
			--password=#{pvt[db_env].pass}
			 #{pvt[db_env].name} > ./database/#{env}/db_#{env}-#{date.format('YYYY-MM-DD-HH-mm-ss')}.sql"
	]

gulp.task "db_dump:dev", () ->
	gulp.src('')
		.pipe db_dump('dev')

gulp.task "db_dump:prod", () ->
	gulp.src('')
		.pipe db_dump('prod')





#*------------------------------------*\
#    $RSYNC
#*------------------------------------*/
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
gulp.task "rsync:updry", ["build"], () ->
  rsyncUp = {
    dest: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}"
    src: conf.rsyncFolders.localFolder,
  }
  opts = extend rsyncUp, conf.ssh, conf.rsyncOpts, conf.rsyncDry
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout


# sync to production
gulp.task "rsync:up", ["build"], () ->
  rsyncUp = {
    src: conf.rsyncFolders.localFolder,
    dest: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}"
  }
  opts = extend rsyncUp, conf.ssh, conf.rsyncOpts
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout

# dry-run deploy to staging
gulp.task "rsync:staging-updry", ["build"], () ->
  rsyncUp = {
    dest: "#{pvt.username}@#{pvt.domain}:#{conf.rsyncFolders.hostFolder}/staging"
    src: conf.rsyncFolders.localFolder,
  }
  opts = extend rsyncUp, conf.ssh, conf.rsyncOpts, conf.rsyncDry
  rsync opts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout


# deploy local changes to staging
gulp.task "rsync:staging-up", ["build"], () ->
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
# No existing gulp task implemented





#*------------------------------------*\
#    $TASKS
#*------------------------------------*/
gulp.task 'default', ['watch']
gulp.task "build", ["uglify", "minify", "font", "imagemin", "rev_replace"]
