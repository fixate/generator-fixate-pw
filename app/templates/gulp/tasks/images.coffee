gulp        = require 'gulp'
imagemin    = require 'gulp-imagemin'
regexRename = require 'gulp-regex-rename'
pngquant    = require 'imagemin-pngquant'

conf = require '../gulpconfig'





#*------------------------------------*\
#     $OPTIMISE SVG PARTIALS
#*------------------------------------*/
gulp.task 'images:svgminify', () ->
  return gulp.src("./#{conf.path.dev.views}/**/*.svg.php", { base: './' })
    .pipe regexRename(/\.php/, '')
    .pipe imagemin {
      svgoPlugins: [
        { removeViewBox: false },
        { cleanupIDs: false },
      ],
    }
    .pipe regexRename(/\.svg/, '.svg.php')
    .pipe gulp.dest('./')

