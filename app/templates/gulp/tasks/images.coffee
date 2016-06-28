gulp        = require 'gulp'
imagemin    = require 'gulp-imagemin'
regexRename = require 'gulp-regex-rename'
pngquant    = require 'imagemin-pngquant'

conf = require '../gulpconfig'




#*------------------------------------*\
#     $MINIFY IMAGES
#*------------------------------------*/
gulp.task 'images:minify', () ->
  gulp.src("#{conf.path.dev.img}/raw/**/*.{jpg,jpeg,png,svg}")
    .pipe imagemin {
      optimizationLevel: 3,
      progressive: true,
      interlaced: true,
      svgoPlugins: [
        { removeViewBox: false },
        { cleanupIDs: false },
      ],
      use: [pngquant()]
    }
    .pipe gulp.dest(conf.path.dev.img)





#*------------------------------------*\
#     $OPTIMISE SVG PARTIALS
#*------------------------------------*/
gulp.task 'images:minify:svgpartials', () ->
  gulp.src("./#{conf.path.dev.views}/partials/svg/raw/**/*.svg")
    .pipe imagemin {
      svgoPlugins: [
        { removeViewBox: false },
        { cleanupIDs: false },
      ],
    }
    .pipe regexRename(/\.svg/, '.svg.php')
    .pipe gulp.dest("#{conf.path.dev.views}/partials/svg")





#*------------------------------------*\
#     $IMAGES WATCH
#*------------------------------------*/
gulp.task 'images:watch', ["images:minify"], () ->
gulp.task 'images:watch:svgpartials', ["images:minify:svgpartials"], () ->
