gulp     = require 'gulp'
favicons = require 'gulp-favicons'
gutil    = require 'gulp-util'
imagemin = require 'gulp-imagemin'
pngquant = require 'imagemin-pngquant'

gulp.task 'favicons', () ->
  gulp.src('./src/device-icon-template.png')
    .pipe favicons({
      background: "#fff"
      display: "browser"
      orientation: "portrait"
      logging: true
      icons:
        android: true
        appleIcon: true
        appleStartup: false
        coast: false
        favicons: false # use x-icon editor for multilayered favicons
        firefox: true
        opengraph: true
        twitter: true
        windows: true
        yandex: false
      }).on 'error', gutil.log
    .pipe imagemin({
      optimizationLevel: 3,
      progressive: true,
      interlaced: true,
      use: [pngquant()]
    })
    .pipe gulp.dest("./src")
