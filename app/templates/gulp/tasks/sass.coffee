gulp         = require "gulp"
autoprefixer = require "gulp-autoprefixer"
plumber      = require "gulp-plumber"
sass         = require "gulp-sass"
sourcemaps   = require "gulp-sourcemaps"



conf = require '../gulpconfig'

handleError = (err) ->
  console.log err.toString()
  if global.isWatching then @emit('end') else process.exit(1)





gulp.task "sass", () ->
  gulp.src(["#{conf.path.dev.scss}/**/*.{scss,sass}"])
    .pipe plumber(conf.plumber)
    .pipe(sourcemaps.init())
    .pipe sass({errLogToConsole: true}).on('error', handleError)
    .pipe(sourcemaps.write('./'))
    .pipe autoprefixer({browsers: ['last 2 versions']})
    .pipe gulp.dest(conf.path.dev.css)
    .pipe global.browserSync.stream match: '**/*.css'