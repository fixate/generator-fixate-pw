gulp        = require 'gulp'
imagemin    = require 'gulp-imagemin'
regexRename = require 'gulp-regex-rename'
rename      = require 'gulp-rename'
replace     = require 'gulp-replace'
pngquant    = require 'imagemin-pngquant'
svgstore    = require 'gulp-svgstore'

conf = require '../gulpconfig'





#*------------------------------------*\
#     $SVG INLINE ICONS
#*------------------------------------*/
gulp.task 'images:minify:inlinesvgicons', () ->
  gulp.src("#{conf.path.dev.img}/raw/svg/inline-icons/*.svg")
    .pipe rename({ prefix: 'icon-' })
    .pipe imagemin {
      svgoPlugins: [
        { removeViewBox: false },
      ],
    }
    .pipe svgstore()
    .pipe regexRename(/\.svg/, '.svg.php')
    .pipe gulp.dest("#{conf.path.dev.views}/partials/svg")





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
    .pipe replace('<g id=', '<g class=')
    .pipe imagemin {
      svgoPlugins: [
        { removeViewBox: false },
      ],
    }
    .pipe regexRename(/\.svg/, '.svg.php')
    .pipe gulp.dest("#{conf.path.dev.views}/partials/svg")





#*------------------------------------*\
#     $IMAGES WATCH
#*------------------------------------*/
gulp.task 'images:watch', ["images:minify"], () ->
gulp.task 'images:watch:svgpartials', ["images:minify:svgpartials"], () ->
gulp.task 'images:watch:inlinesvgicons', ["images:minify:inlinesvgicons"], () ->
