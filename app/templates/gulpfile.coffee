# Gulp
gulp       = require "gulp"
cache      = require "gulp-cache"
coffee     = require "gulp-coffee"
concat     = require "gulp-concat"
exec       = require "gulp-exec"
imagemin   = require "gulp-imagemin"
minifyCSS  = require "gulp-minify-css"
plumber    = require "gulp-plumber"
remember   = require "gulp-remember"
rename     = require "gulp-rename"
replace    = require 'gulp-replace'
rev        = require 'gulp-rev'
sass       = require "gulp-sass"
sourcemaps = require "gulp-sourcemaps"
shell      = require "gulp-shell"
uglifyJs   = require "gulp-uglify"
gutil      = require "gulp-util"
watch      = require "gulp-watch"

browserSync  = require "browser-sync"
cp           = require "child_process"
extend       = require "extend"
moment       = require "moment"
pngquant     = require "imagemin-pngquant"
reload       = browserSync.reload
rsyncwrapper = require "rsyncwrapper"
rsync        = rsyncwrapper.rsync
spawn        = cp.spawn

pkg  = require "./package.json"
conf = require "./gulpconfig.json"

try
  scrt = require "./secrets.json"
catch err
  console.log err





#*-------------------------------------*\
# $BROWSER-SYNC
#*-------------------------------------*/
gulp.task 'browser-sync', () ->
  browserSync {
    proxy: scrt.bsProxy
    injectchanges: true
    open: false
    # tunnel: true
  }






#*-------------------------------------*\
# $RELOAD
#*-------------------------------------*/
gulp.task 'bs-reload', () ->
  reload()





#*------------------------------------*\
#     $SASS
#*------------------------------------*/
gulp.task "sass", () ->
  gulp.src(["#{conf.path.dev.scss}/**/*.{scss,sass}"])
    .pipe plumber(conf.plumber)
    .pipe(sourcemaps.init())
      .pipe sass({errLogToConsole: true})
    .pipe(sourcemaps.write('./'))
    .pipe gulp.dest(conf.path.dev.css)
    .pipe reload({stream: true})





#*------------------------------------*\
#     $PIXEL &
#     $VECTOR OPTIM
#*------------------------------------*/
gulp.task 'imagemin', () ->
  files = ['jpg', 'jpeg', 'png', 'svg'].map (ext) ->
    "#{conf.path.dev.img}/**/*.#{ext}"

  return gulp.src(files)
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
    .pipe gulp.dest conf.path.prod.img
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $AUTO RELOAD GULPFILE ON SAVE
#     noxoc.de/2014/06/25/reload-gulpfile-js-on-change/
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
#     $COFFEE
#*------------------------------------*/
gulp.task "coffee", () ->
  gulp.src ["#{conf.path.dev.coffee}/**/*.coffee"]
    .pipe plumber(conf.plumber)
    .pipe cache(coffee({bare: true}).on('error', gutil.log))
    .pipe remember()
    .pipe gulp.dest(conf.path.dev.js)
    .pipe reload({stream: true})
  return





#*------------------------------------*\
#     $WATCH
#*------------------------------------*/
gulp.task "watch", ["sass", "coffee", "browser-sync"], () ->
  gulp.watch "#{conf.path.dev.scss}/**/*.scss", ["sass"]
  gulp.watch "#{conf.path.dev.coffee}/**/*.coffee", ["coffee", "bs-reload"]
  gulp.watch "#{conf.path.dev.views}/**/*.html.php", ["bs-reload"]





#*------------------------------------*\
#     $UGLIFY
#*------------------------------------*/
gulp.task "uglify", ["coffee"], () ->
  gulp.src ["#{conf.path.dev.js}/main.js"]
  .pipe uglifyJs()
  .pipe rev()
  .pipe rename({suffix: '.min'})
  .pipe gulp.dest(conf.path.prod.js)
  .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
  .pipe gulp.dest('./')





#*------------------------------------*\
#     $MINIFY
#*------------------------------------*/
gulp.task "minify", ["sass"], () ->
  gulp.src(["#{conf.path.dev.css}/style.css"])
    .pipe minifyCSS({keepSpecialComments: 0})
    .pipe rev()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(conf.path.prod.css)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $FONT REV
#*------------------------------------*/
gulp.task "font", () ->
  files = ['eot', 'woff', 'ttf', 'svg'].map (curr) ->
    "#{conf.path.dev.fnt}/**/*#{curr}"

  gulp.src(files)
    .pipe cache(rev())
    .pipe remember()
    .pipe gulp.dest(conf.path.prod.fnt)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV REPLACE
#     github.com/jamesknelson/gulp-rev-replace/issues/23
#*------------------------------------*/
gulp.task 'rev_replace', ["uglify", "minify", "font", "imagemin"], () ->
  manifest = require "./#{conf.path.dev.assets}/rev-manifest.json"
  stream = gulp.src ["./#{conf.path.prod.css}/#{manifest['style.css']}"]

  Object.keys(manifest).reduce((stream, key) ->
    stream.pipe replace(key, manifest[key])
  , stream)
    .pipe gulp.dest("./#{conf.path.prod.css}")





#*------------------------------------*\
#     $MYSQL-DUMP
#*------------------------------------*/
dbDump = (env) ->
  date = moment()
  dbEnv = "db_#{env}"

  shell [
    "mysqldump --host=#{scrt[dbEnv].host}
      --user=#{scrt[dbEnv].user}
      --password=#{scrt[dbEnv].pass}
       #{scrt[dbEnv].name} > ./database/#{env}/#{dbEnv}-#{date.format('YYYY-MM-DD-HH-mm-ss')}.sql"
  ]

gulp.task "db-dump:dev", () ->
  gulp.src('')
    .pipe dbDump('dev')

gulp.task "db-dump:prod", () ->
  gulp.src('')
    .pipe dbDump('prod')





#*------------------------------------*\
#     $RSYNC
#*------------------------------------*/
doRsync = (type, opts, rsyncOpts = {}) ->
  opts =
    isDry: opts.isDry || false
    isToRemote: opts.isToRemote || true

  if opts.isToRemote
    dest = "#{scrt.username}@#{scrt.domain}:#{conf.rsync[type].src}"
    src = conf.rsync[type].src
  else
    dest = conf.rsync[type].dest
    src = "#{scrt.username}@#{scrt.domain}:#{conf.rsync[type].dest}"

  rsyncOpts = extend {
    dest: dest
    src: src
    dryRun: dryRun
    exclude: conf.rsync[type].exclude || ""
    port: conf.ssh.port
    ssh: true
    recursive: true
    compareMode: "checksum"
  }, rsyncOpts

  rsync rsyncOpts, (error, stdout, stderr, cmd) ->
    gutil.log stderr
    gutil.log stdout


# dry-run down
gulp.task "rsync:downdry", () ->
  doRsync "down", {isToRemote: false, isDry: true}

# sync down
gulp.task "rsync:downdry", () ->
  doRsync "down", {isToRemote: false}

# dry-run sync to prod
gulp.task "rsync:updry", ["build"], () ->
  doRsync "up", {isDry: true}

# sync to production
gulp.task "rsync:up", ["build"], () ->
  doRsync "up"





#*------------------------------------*\
#     $UPDATE NPM DEPS
#*------------------------------------*/
gulp.task 'update_deps', shell.task 'npm-check-updates -u'





#*------------------------------------*\
#     $TASKS
#*------------------------------------*/
gulp.task 'default', ['watch']
gulp.task "build", ["uglify", "minify", "font", "imagemin", "rev_replace"]
