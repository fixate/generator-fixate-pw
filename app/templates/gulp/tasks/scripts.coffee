gulp       = require "gulp"
gutil      = require "gulp-util"
babelify   = require "babelify"
browserify = require "browserify"
es         = require "event-stream"
eslint     = require "gulp-eslint"
rename     = require "gulp-rename"
source     = require "vinyl-source-stream"
transform  = require "vinyl-transform"

path       = require("../gulpconfig").path

bundleScripts = (files) ->
  tasks = files.map (entry) ->
    browserify({ entries: [entry], debug: true })
      .transform(babelify, {presets: ['react', 'es2015', 'stage-0']})
      .bundle().on('error', (err) ->
        gutil.log(err.message)
        this.emit 'end'
      )
      .pipe(source(entry))
      .pipe(rename({
        extname: '.bundle.js'
      }))
      .pipe(gulp.dest('./'))

  es.merge.apply(null, tasks)





#*------------------------------------*\
#     $SCRIPTS
#*------------------------------------*/
gulp.task 'scripts',  () ->
  files = [
    "#{path.dev.js}/map.js"
  ]

  bundleScripts(files)





#*------------------------------------*\
#     $SCRIPTS VENDORS
#*------------------------------------*/
gulp.task 'scripts:vendors', () ->
  # files = [
  #   "#{path.dev.js}/vendor.js"
  # ]

  # bundleScripts(files)





#*------------------------------------*\
#     $LINT
#*------------------------------------*/
gulp.task 'scripts:lint',  () ->
  files = [
    "#{path.dev.js}/**/!(*.bundle).js"
  ]

  gulp.src(files)
    .pipe(eslint())
    .pipe(eslint.format())
