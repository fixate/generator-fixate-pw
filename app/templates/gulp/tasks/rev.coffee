gulp         = require "gulp"
imagemin     = require 'gulp-imagemin'
pngquant     = require 'imagemin-pngquant'
rename       = require "gulp-rename"
replace      = require "gulp-replace"
rev          = require 'gulp-rev'

conf = require '../gulpconfig'




#*------------------------------------*\
#     $REV CSS
#*------------------------------------*/
gulp.task "rev:css", ["minify:css"], () ->
  gulp.src(["#{conf.path.prod.css}/style.min.css"])
    .pipe rev()
    .pipe gulp.dest(conf.path.prod.css)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV SCRIPTS
#*------------------------------------*/
gulp.task 'rev:scripts', ["minify:scripts"], () ->
  gulp.src(["#{conf.path.prod.js}/main.bundle.min.js"])
    .pipe rev()
    .pipe gulp.dest(conf.path.prod.js)
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV FONTS
#*------------------------------------*/
gulp.task "rev:fonts", () ->
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
        { removeViewBox: false }
      ],
      use: [pngquant()]
    }
    .pipe rev()
    .pipe gulp.dest conf.path.prod.img
    .pipe rev.manifest(conf.revManifest.path, conf.revManifest.opts)
    .pipe gulp.dest('./')





#*------------------------------------*\
#     $REV REPLACE
#     github.com/jamesknelson/gulp-rev-replace/issues/23
#*------------------------------------*/
gulp.task 'rev:replace', ["rev:css", "rev:scripts"], () ->
  manifest = require "../../#{conf.path.dev.assets}/rev-manifest.json"
  cssStream = gulp.src ["../../#{conf.path.prod.css}/#{manifest['style.css']}"]

  Object.keys(manifest).reduce((cssStream, key) ->
    regkey = key.replace('/', '\\/')
    cssStream.pipe replace(new RegExp("(" + regkey + ")(?!\\w)", "g"), manifest[key])
  , cssStream)
    .pipe gulp.dest("./#{conf.path.prod.css}")
