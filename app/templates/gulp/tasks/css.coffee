gulp         = require 'gulp'
autoprefixer = require 'gulp-autoprefixer'
sass         = require 'gulp-sass'
sourcemaps   = require 'gulp-sourcemaps'

conf = require '../gulpconfig'





#*------------------------------------*\
#     $CSS
#*------------------------------------*/
gulp.task 'css', () ->
  gulp.src(["#{conf.path.dev.scss}/**/*.{scss,sass}"])
    .pipe sourcemaps.init()
    .pipe sass().on('error', sass.logError)
    .pipe autoprefixer({browsers: ['last 2 versions']})
    .pipe sourcemaps.write()
    .pipe gulp.dest(conf.path.dev.css)





#*------------------------------------*\
#     $CSS WATCH
#*------------------------------------*/
gulp.task 'css:watch', ['css'], () ->
  global.browserSync.reload('*.css')
