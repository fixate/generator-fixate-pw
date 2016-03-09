gulp        = require 'gulp'
assign      = require 'object.assign'
eslint      = require 'gulp-eslint'
webpack     = require 'webpack'

path        = require('../gulpconfig').path
webpackConf = require '../webpack.config.base'

runWebPack = (entries, config, done) ->
  config = assign {entry: entries}, config, webpackConf

  webpack(config).run (err, stats) ->
    if err
      console.log 'Error', err
    else
      console.log stats.toString({ chunks: false })

    done()





#*------------------------------------*\
#     $SCRIPTS
#*------------------------------------*/
gulp.task 'scripts',  (done) ->
  # entries compile to [name].bundle.js
  entries =
    "main": "./#{path.dev.js}/main.js"

  runWebPack(entries, {}, done)






#*------------------------------------*\
#     $SCRIPTS WATCH
#*------------------------------------*/
gulp.task 'scripts:watch', ['scripts'],  (done) ->
  global.browserSync.reload()





#*------------------------------------*\
#     $SCRIPTS VENDORS
#*------------------------------------*/
gulp.task 'scripts:vendors', (done) ->
  # files = [
  #   "#{path.dev.js}/vendor.js"
  # ]

  # runWebPack(entries, {}, done)
  #





#*------------------------------------*\
#     $LINT
#*------------------------------------*/
gulp.task 'scripts:lint',  () ->
  files = [
    "#{path.dev.js}/**/!(*.bundle).js"
    "#{path.dev.js}/**/*.jsx"
  ]

  gulp.src(files)
    .pipe(eslint())
    .pipe(eslint.format())

