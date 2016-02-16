gulp         = require "gulp"
autoprefixer = require "gulp-autoprefixer"
sass         = require "gulp-sass"
sourcemaps   = require "gulp-sourcemaps"



conf = require '../gulpconfig'




gulp.task "css", () ->
  gulp.src(["#{conf.path.dev.scss}/**/*.{scss,sass}"])
    .pipe(sass().on('error', sass.logError))
    .pipe autoprefixer({browsers: ['last 2 versions']})
    .pipe gulp.dest(conf.path.dev.css)
    .pipe global.browserSync.stream match: '**/*.css'
