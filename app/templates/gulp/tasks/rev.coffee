gulp        = require 'gulp'
gulpif      = require 'gulp-if'
regexRename = require 'gulp-regex-rename'
rename      = require 'gulp-rename'
replace     = require 'gulp-replace'
rev         = require 'gulp-rev'
revReplace  = require 'gulp-rev-replace'

conf = require '../gulpconfig'

revMinifiedFiles = (files, dest) ->
  gulp.src(files)
    .pipe regexRename(/\.min/, '')
    .pipe replace(/templates\/assets/g, 'templates/assets/public')
    .pipe rev()
    .pipe rename({suffix: '.min'})
    .pipe gulp.dest(dest)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV CSS
#*------------------------------------*/
gulp.task 'rev:css', ['minify:css'], () ->
  revMinifiedFiles(["#{conf.path.prod.css}/*.min.css"], conf.path.prod.css)





#*------------------------------------*\
#     $REV SCRIPTS
#*------------------------------------*/
gulp.task 'rev:scripts', ['minify:scripts'], () ->
  revMinifiedFiles(["#{conf.path.prod.js}/*.bundle.min.js"], conf.path.prod.js)





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
gulp.task 'rev:images', ['images:minify'], () ->
  return gulp.src("#{conf.path.dev.img}/**/*.{jpg,jpeg,png,svg}")
    .pipe rev()
    .pipe gulp.dest conf.path.prod.img
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV REPLACE
#*------------------------------------*/
gulp.task 'rev:replace', ['rev:css', 'rev:scripts'], () ->
  manifest = gulp.src("./#{conf.revManifest.path}")

  # we need a replace wrapping revReplace it doesn't replace js 'style.css'
  # node properties with a rev'd filename
  gulp.src(["#{conf.path.prod.css}/*.css", "#{conf.path.prod.js}/*.js"], { base: './' })
    .pipe replace(/style\.css/g, 'styleCssTmp')
    .pipe revReplace({ manifest: manifest })
    .pipe replace(/styleCssTmp/g, 'style.css')
    .pipe gulp.dest('./')

