gulp        = require 'gulp'
imagemin    = require 'gulp-imagemin'
pngquant    = require 'imagemin-pngquant'
rename      = require 'gulp-rename'
regexRename = require 'gulp-regex-rename'
replace     = require 'gulp-replace'
rev         = require 'gulp-rev'
revReplace  = require 'gulp-rev-replace'


conf = require '../gulpconfig'





#*------------------------------------*\
#     $REV CSS
#*------------------------------------*/
gulp.task 'rev:css', ['minify:css'], () ->
  gulp.src(["#{conf.path.prod.css}/style.min.css"])
    .pipe regexRename(/\.min/, '')
    .pipe rev()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(conf.path.prod.css)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV SCRIPTS
#*------------------------------------*/
gulp.task 'rev:scripts', ['minify:scripts'], () ->
  gulp.src(["#{conf.path.prod.js}/*.bundle.min.js"])
    .pipe regexRename(/\.min/, '')
    .pipe rev()
    .pipe rename({ suffix: '.min' })
    .pipe gulp.dest(conf.path.prod.js)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV FONTS
#*------------------------------------*/
gulp.task 'rev:fonts', () ->
  files = ['eot', 'woff', 'woff2', 'ttf', 'svg'].map (curr) ->
    "#{conf.path.dev.fnt}/**/*#{curr}"

  gulp.src(files)
    .pipe rev()
    .pipe gulp.dest(conf.path.prod.fnt)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV IMAGES & OPTIMISE
#*------------------------------------*/
gulp.task 'rev:images', () ->
  return gulp.src("#{conf.path.dev.img}/**/*.{jpg,jpeg,png,svg}")
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
    .pipe rev()
    .pipe gulp.dest conf.path.prod.img
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV REPLACE
#*------------------------------------*/
gulp.task 'rev:replace', ['rev:css', 'rev:scripts'], () ->
  manifest = gulp.src("./#{conf.revManifest.path}")

  gulp.src(["#{conf.path.prod.css}/*.css", "#{conf.path.prod.js}/*.js"], { base: './' })
    .pipe revReplace({ manifest: manifest })
    .pipe gulp.dest('./')
