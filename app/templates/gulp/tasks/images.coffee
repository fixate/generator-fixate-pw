gulp       = require 'gulp'
imagemin   = require 'gulp-imagemin'
rename     = require 'gulp-rename'
pngquant   = require 'imagemin-pngquant'

conf = require '../gulpconfig'





#*------------------------------------*\
#     $OPTIMISE SVG PARTIALS
#*------------------------------------*/
gulp.task 'images:svgminify', () ->
  return gulp.src("./#{conf.path.dev.views}/**/*.svg.php", { base: './' })
    .pipe rename({ suffix: '', extname: '' })
    .pipe imagemin {
      svgoPlugins: [
        { removeViewBox: false },
        { cleanupIDs: false },
      ],
    }
    .pipe rename({ suffix: '.svg', extname: '.php' })
    .pipe gulp.dest('./')
