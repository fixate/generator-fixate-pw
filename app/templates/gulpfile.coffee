# Gulp
gulp       = require "gulp"
coffee     = require "gulp-coffee"
concat     = require "gulp-concat"
exec       = require "gulp-exec"
imagemin   = require "gulp-imagemin"
minifyCSS  = require "gulp-minify-css"
plumber    = require "gulp-plumber"
rename     = require "gulp-rename"
replace    = require 'gulp-replace'
rev        = require 'gulp-rev'
sass       = require "gulp-sass"
sourcemaps = require "gulp-sourcemaps"
shell      = require "gulp-shell"
uglifyJs   = require "gulp-uglify"
gutil      = require "gulp-util"
watch      = require "gulp-watch"

bs           = require("browser-sync").create()
cp           = require "child_process"
del          = require "del"
extend       = require "extend"
moment       = require "moment"
pngquant     = require "imagemin-pngquant"
rsync        = require("rsyncwrapper").rsync
runSequence  = require "run-sequence"
spawn        = cp.spawn

pkg  = require "./package.json"
conf = require "./gulpconfig.json"

try
  scrt = require "./secrets.json"
catch err
  console.log err





#*------------------------------------*\
#     $HANDLE ERRORS
#*------------------------------------*/
watching = false

handleError = (err) ->
  console.log err.toString()
  if watching then @emit('end') else process.exit(1)





#*-------------------------------------*\
#     $BROWSER-SYNC
#*-------------------------------------*/
gulp.task 'browser-sync', () ->
  bs.init {
    proxy: scrt.bsProxy
    injectchanges: true
    open: false
    # notify: false
    # tunnel: true
  }





#*-------------------------------------*\
#     $RELOAD
#*-------------------------------------*/
gulp.task 'bs-reload', () ->
  bs.reload()





#*------------------------------------*\
#     $COMPILE SASS
#*------------------------------------*/
gulp.task "sass", () ->
  gulp.src(["#{conf.path.dev.scss}/**/*.{scss,sass}"])
    .pipe plumber(conf.plumber)
    .pipe(sourcemaps.init())
    .pipe sass({errLogToConsole: true}).on('error', handleError)
    .pipe(sourcemaps.write('./'))
    .pipe gulp.dest(conf.path.dev.css)
    .pipe bs.stream match: '**/*.css'





#*------------------------------------*\
#     $COMPILE COFFEE
#*------------------------------------*/
gulp.task "coffee", () ->
  gulp.src ["./#{conf.path.dev.coffee}/**/*.coffee"]
    .pipe plumber(conf.plumber)
    .pipe coffee({bare: true}).on('error', gutil.log)
    .pipe gulp.dest(conf.path.dev.js)
    .pipe bs.reload({stream: true})





#*------------------------------------*\
#     $CONCAT JS
#*------------------------------------*/
gulp.task "concat", ["coffee"], () ->
  gulp.src [
    "#{conf.path.dev.coffee}/lib/toggler.js"
    "#{conf.path.dev.coffee}/main.js"
  ]
    .pipe concat('built.js')
    .pipe gulp.dest(conf.path.dev.js)
    .pipe bs.reload({stream: true})





#*------------------------------------*\
#     $MINIFY CSS
#*------------------------------------*/
gulp.task "minify:css", ["sass"], () ->
  gulp.src(["#{conf.path.dev.css}/style.css"])
    .pipe minifyCSS({keepSpecialComments: 0})
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(conf.path.dev.css)





#*------------------------------------*\
#     $MINIFY JS
#*------------------------------------*/
gulp.task "minify:js", ["concat"], () ->
  files = [
    "#{conf.path.dev.js}/built.js"
  ]

  gulp.src files
    .pipe uglifyJs()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(conf.path.dev.js)





#*------------------------------------*\
#     $MINIFY VENDORS
#*------------------------------------*/
gulp.task "minify:js:vendors", () ->
  files = [
    # "./#{conf.path.dev.assets}/**/vendor/[path/to/your/vendor].js",
  ]

  gulp.src files
    .pipe uglifyJs()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV CSS
#*------------------------------------*/
gulp.task "rev:css", ["minify:css"], () ->
  gulp.src(["#{conf.path.dev.css}/style.min.css"])
    .pipe rename('style.css')
    .pipe rev()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(conf.path.prod.css)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV JS
#*------------------------------------*/
gulp.task 'rev:js', ["minify:js"], () ->
  gulp.src(["#{conf.path.dev.js}/built.min.js"])
    .pipe rename('built.js')
    .pipe rev()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(conf.path.prod.js)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV FONTS
#*------------------------------------*/
gulp.task "rev:fonts", () ->
  files = ['eot', 'woff', 'woff2', 'ttf', 'svg'].map (curr) ->
    "#{conf.path.dev.fnt}/**/*#{curr}"

  gulp.src(files)
    .pipe rev()
    .pipe gulp.dest(conf.path.prod.fnt)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV IMAGES & OPTIMISE
#*------------------------------------*/
gulp.task 'rev:images', () ->
  return gulp.src("#{conf.path.dev.img}/**/*.{jpg,jpeg,png,svg}")
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
    .pipe rev()
    .pipe gulp.dest conf.path.prod.img
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV REPLACE
#     github.com/jamesknelson/gulp-rev-replace/issues/23
#*------------------------------------*/
gulp.task 'rev:replace', ["rev:css", "rev:js"], () ->
  manifest = require "./#{conf.path.dev.assets}/rev-manifest.json"
  cssStream = gulp.src ["./#{conf.path.prod.css}/#{manifest['style.css']}"]

  Object.keys(manifest).reduce((cssStream, key) ->
    regkey = key.replace('/', '\\/')
    cssStream.pipe replace(new RegExp("(" + regkey + ")(?!\\w)", "g"), manifest[key])
  , cssStream)
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
_rsyncDo = (rsyncOpts = {}) ->
  rsyncOpts = extend {
    port: conf.ssh.port
    ssh: true
    recursive: true
    compareMode: "checksum"
    args: ["--verbose"]
  }, rsyncOpts

  gutil.log "Rsyncing from #{rsyncOpts.src} to #{rsyncOpts.dest}"

  rsync rsyncOpts, (error, stdout, stderr, cmd) ->
    gutil.log error if error
    gutil.log cmd, stderr, stdout

_rsyncPrepare = (prop, isToRemote = true, rsyncOpts = {}) ->
  ["dest", "src"].forEach (curr) ->
    remoteHost = "#{scrt.username}@#{scrt.domain}:"
    rsyncOpts[curr] = if rsyncOpts[curr] then rsyncOpts[curr] else conf.rsync[prop][curr]

    rsyncOpts[curr] = "#{remoteHost}#{rsyncOpts[curr]}" if isToRemote && curr == "dest"
    rsyncOpts[curr] = "#{remoteHost}#{rsyncOpts[curr]}" if !isToRemote && curr == "src"

  rsyncOpts.exclude = conf.rsync[prop].exclude || ""

  _rsyncDo(rsyncOpts)

# dry-run down
gulp.task "rsync:downdry", () ->
  _rsyncPrepare "down", false, dryRun: true

# sync down
gulp.task "rsync:down", () ->
  _rsyncPrepare "down", false

# dry-run sync to prod
gulp.task "rsync:updry", ["build"], () ->
  _rsyncPrepare "up", true, dryRun: true

# sync to production
gulp.task "rsync:up", ["build"], () ->
  _rsyncPrepare "up"





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
#     $UPDATE NPM DEPS
#*------------------------------------*/
gulp.task 'update_deps', shell.task 'npm-check-updates -u'





#*-------------------------------------*\
#      $CLEAN
#*-------------------------------------*/
gulp.task 'clean:build', (done) ->
  del ["#{conf.path.prod.assets}/**/*", "#{conf.path.dev.assets}/rev-manifest.json"], done





#*-------------------------------------*\
#      $BUILD
#*-------------------------------------*/
gulp.task 'build', () ->
  runSequence "clean:build", "rev:fonts", "rev:images", ["rev:replace", "minify:js:vendors"]





#*------------------------------------*\
#     $WATCH
#*------------------------------------*/
gulp.task "watch", ["sass", "coffee", "browser-sync"], () ->
  watching = true

  gulp.watch "#{conf.path.dev.scss}/**/*.scss", ["sass"]
  gulp.watch "#{conf.path.dev.coffee}/**/*.coffee", ["concat", "bs-reload"]
  gulp.watch "#{conf.path.dev.views}/**/*.html.php", ["bs-reload"]





#*------------------------------------*\
#     $TASKS
#*------------------------------------*/
gulp.task 'default', ['sass', 'concat', 'watch']
