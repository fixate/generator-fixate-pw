gulp         = require "gulp"
imagemin     = require "gulp-imagemin"
minifyCSS    = require "gulp-minify-css"
pngquant     = require "imagemin-pngquant"

conf = require '../gulpconfig'




#*------------------------------------*\
#     $MINIFY CSS
#*------------------------------------*/
gulp.task "minify:css", ["sass"], () ->
  gulp.src(["#{conf.path.dev.css}/style.css"])
    .pipe minifyCSS({keepSpecialComments: 0})
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(conf.path.dev.css)





#*------------------------------------*\
#     $MINIFY JS
#*------------------------------------*/
gulp.task "minify:js", ["coffee"], () ->
  files = [
    "#{conf.path.dev.js}/built.js"
  ]

  gulp.src files
    .pipe uglifyJs()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(conf.path.dev.js)


gulp.task "minify:js:vendors", () ->
  files = [
    # "./#{conf.path.dev.assets}/**/vendor/[path/to/your/vendor].js",
  ]

  gulp.src files
    .pipe uglifyJs()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $MINIFY IMAGES
#*------------------------------------*/
gulp.task 'minify:images', () ->
  gulp.src("#{conf.path.dev.img}/**/*.{jpg,jpeg,png,svg}")
    .pipe imagemin({
      progressive: true,
      svgoPlugins: [{removeViewBox: false}],
      use: [pngquant()]
    })
    .pipe gulp.dest(conf.path.dev.img)
