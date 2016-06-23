gulp        = require 'gulp'
eslint      = require 'gulp-eslint'
webpack     = require 'webpack'

path           = require('../gulpconfig').path
webpackDevConf = require '../../webpack.config.dev'
webpackConf =
  dev: webpackDevConf

runWebPack = (config, done) ->
  config = Object.assign(config, webpackConf.dev)

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

  runWebPack({ entry: entries }, done)






#*------------------------------------*\
#     $SCRIPTS WATCH
#*------------------------------------*/
gulp.task 'scripts:watch', ['scripts'],  () ->
  global.browserSync.reload()





#*------------------------------------*\
#     $SCRIPTS VENDORS
#*------------------------------------*/
gulp.task 'scripts:vendors', (done) ->
  # entries =
  #   "vendor": "./#{path.dev.js}/vendor.js"

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
