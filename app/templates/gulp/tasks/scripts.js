const gulp = require('gulp');
const eslint = require('gulp-eslint');
const webpack = require('webpack');

const path = require('../gulpconfig').path;
const webpackConfDev = require('../../webpack.config.dev');
const webpackConfProd = require('../../webpack.config.prod');

const runWebPack = (done, env = 'development') => {
  const webpackConf = env === 'development' ? webpackConfDev : webpackConfProd;
  const entry = {
    main: `./${path.dev.js}/main.js`,
  };

  const cfg = Object.assign({}, {entry}, webpackConf);

  return webpack(cfg).run(function(err, stats) {
    if (err) {
      console.log('Error', err);
      return done();
    } else {
      console.log(
        stats.toString({chunks: false, modules: false, colors: true}),
      );
    }

    return done();
  });
};

//*------------------------------------*\
//     $SCRIPTS
//*------------------------------------*/
const scripts = gulp.task('scripts', done => runWebPack(done));

//*------------------------------------*\
//     $SCRIPTS MINIFY
//*------------------------------------*/
const scriptsMinify = gulp.task('scripts:minify', done =>
  runWebPack(done, 'production'),
);

//*------------------------------------*\
//     $SCRIPTS WATCH
//*------------------------------------*/
const scriptsWatch = gulp.task(
  'scripts:watch',
  gulp.series('scripts', done => {
    global.browserSync.reload();

    return done();
  }),
);

//*------------------------------------*\
//     $LINT
//*------------------------------------*/
const scriptsLint = gulp.task('scripts:lint', done => {
  const files = [`${path.dev.js}/**/!(*.bundle).js`, `${path.dev.js}/**/*.jsx`];

  gulp
    .src(files)
    .pipe(eslint())
    .pipe(eslint.format());

  return done();
});

module.exports = {
  scripts,
  scriptsLint,
  scriptsMinify,
  scriptsWatch,
};
