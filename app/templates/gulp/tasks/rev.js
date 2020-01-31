const gulp = require('gulp');
const gulpif = require('gulp-if');
const rename = require('gulp-rename');
const replace = require('gulp-replace');
const rev = require('gulp-rev');
const gulpRevReplace = require('gulp-rev-replace');

const conf = require('../gulpconfig');

require('./scripts');
require('./css');

const revMinifiedFiles = (files, dest) => {
  return gulp
    .src(files)
    .pipe(
      rename(path => {
        path.extname = path.extname.replace('.min', '');
      }),
    )
    .pipe(replace(/templates\/assets/g, 'templates/assets/public'))
    .pipe(rev())
    .pipe(
      rename(path => {
        path.extname = `.min${path.extname}`;
      }),
    )
    .pipe(gulp.dest(dest))
    .pipe(rev.manifest(conf.revManifest.path, conf.revManifest.opts))
    .pipe(gulp.dest('./'));
};

/*------------------------------------*\
     $REV CSS
\*------------------------------------*/
const revCss = gulp.task(
  'rev:css',
  gulp.series('css:minify', () =>
    revMinifiedFiles([`${conf.path.prod.css}/*.min.css`], conf.path.prod.css),
  ),
);

/*------------------------------------*\
     $REV SCRIPTS
\*------------------------------------*/
const revScripts = gulp.task(
  'rev:scripts',
  gulp.series('scripts:minify', () =>
    revMinifiedFiles(
      [`${conf.path.prod.js}/*.bundle.min.js`],
      conf.path.prod.js,
    ),
  ),
);

/*------------------------------------*\
     $REV FONTS
\*------------------------------------*/
const revFonts = gulp.task('rev:fonts', () => {
  const files = ['eot', 'woff', 'woff2', 'ttf', 'svg'].map(
    curr => `${conf.path.dev.fnt}/**/*${curr}`,
  );

  return gulp
    .src(files)
    .pipe(rev())
    .pipe(gulp.dest(conf.path.prod.fnt))
    .pipe(rev.manifest(conf.revManifest.path, conf.revManifest.opts))
    .pipe(gulp.dest('./'));
});

/*------------------------------------*\
     $REV IMAGES & OPTIMISE
\*------------------------------------*/
const revImages = gulp.task(
  'rev:images',
  gulp.series('images:minify', () => {
    return gulp
      .src(`${conf.path.dev.img}/**/*.{jpg,jpeg,png,svg}`)
      .pipe(rev())
      .pipe(gulp.dest(conf.path.prod.img))
      .pipe(rev.manifest(conf.revManifest.path, conf.revManifest.opts))
      .pipe(gulp.dest('./'));
  }),
);

/*------------------------------------*\
     $REV REPLACE
\*------------------------------------*/
const revReplace = gulp.task(
  'rev:replace',
  gulp.series(gulp.parallel('rev:css', 'rev:scripts'), () => {
    const manifest = gulp.src(`./${conf.revManifest.path}`, {
      allowEmpty: true,
    });

    // we need a 'replace' wrapping revReplace otherwise it doesn't replace js 'style.css'
    // node properties with a rev'd filename
    return gulp
      .src([`${conf.path.prod.css}/*.css`, `${conf.path.prod.js}/*.js`], {
        base: './',
      })
      .pipe(replace(/style\.css/g, 'styleCssTmp'))
      .pipe(gulpRevReplace({manifest}))
      .pipe(replace(/styleCssTmp/g, 'style.css'))
      .pipe(gulp.dest('./'));
  }),
);

module.exports = {
  revCss,
  revFonts,
  revImages,
  revReplace,
  revScripts,
};
