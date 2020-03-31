const gulp = require('gulp');
const imagemin = require('gulp-imagemin');
const rename = require('gulp-rename');
const replace = require('gulp-replace');
const pngquant = require('imagemin-pngquant');
const svgstore = require('gulp-svgstore');

const conf = require('../gulpconfig');

//*------------------------------------*\
//     $SVG INLINE ICONS
//*------------------------------------*/
const imagesMinifyInlineSvgIcons = gulp.task(
  'images:minify:inlinesvgicons',
  done => {
    gulp
      .src(`${conf.path.dev.img}/raw/svg/inline-icons/*.svg`)
      .pipe(rename({prefix: 'icon-'}))
      .pipe(
        imagemin([
          imagemin.svgo({
            plugins: [{removeViewBox: false}],
          }),
        ]),
      )
      .pipe(svgstore({inlineSvg: true}))
      .pipe(rename({extname: '.svg.php'}))
      .pipe(gulp.dest(`${conf.path.dev.views}/partials/svg`));

    return done();
  },
);

//*------------------------------------*\
//     $MINIFY IMAGES
//*------------------------------------*/
const imagesMinify = gulp.task('images:minify', done => {
  gulp
    .src(`${conf.path.dev.img}/raw/**/*.{jpg,jpeg,png,svg}`)
    .pipe(
      imagemin([
        imagemin.gifsicle({interlaced: true}),
        imagemin.mozjpeg({progressive: true}),
        imagemin.optipng({optimizationLevel: 3}),
        imagemin.svgo({
          plugins: [{removeViewBox: false}, {cleanupIDs: false}],
        }),
      ]),
    )
    .pipe(gulp.dest(conf.path.dev.img));

  return done();
});

//*------------------------------------*\
//     $OPTIMISE SVG PARTIALS
//*------------------------------------*/
const imagesMinifySvgPartials = gulp.task('images:minify:svgpartials', done => {
  gulp
    .src(`./${conf.path.dev.views}/partials/svg/raw/**/*.svg`)
    .pipe(replace('<g id=', '<g class='))
    .pipe(
      imagemin([
        imagemin.svgo({
          plugins: [{removeViewBox: false}, {cleanupIDs: {prefix: 'svgo-'}}],
        }),
      ]),
    )
    .pipe(rename({extname: '.svg.php'}))
    .pipe(gulp.dest(`${conf.path.dev.views}/partials/svg`));

  return done();
});

//*------------------------------------*\
//     $IMAGES WATCH
//*------------------------------------*/
const imagesWatch = gulp.task(
  'images:watch',
  gulp.series('images:minify', done => done()),
);
gulp.task(
  'images:watch:svgpartials',
  gulp.series('images:minify:svgpartials', done => done()),
);
gulp.task(
  'images:watch:inlinesvgicons',
  gulp.series('images:minify:inlinesvgicons', done => done()),
);

module.exports = {
  imagesMinifyInlineSvgIcons,
  imagesMinifySvgPartials,
  imagesWatch,
};
