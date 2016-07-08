const gulp    = require('gulp');
const eslint  = require('gulp-eslint');
const webpack = require('webpack');

const path           = require('../gulpconfig').path;
const webpackDevConf = require('../../webpack.config.dev');
const webpackConf    = {
  dev: webpackDevConf
};

function runWebPack(config, done) {
  config = Object.assign(config, webpackConf.dev);

  return webpack(config).run(function(err, stats) {
    if (err) {
      console.log('Error', err);
    } else {
      console.log(stats.toString({ chunks: false }));
    }

    return done();
  });
};





//*------------------------------------*\
//     $SCRIPTS
//*------------------------------------*/
gulp.task('scripts',  function(done) {
  // entries compile to [name].bundle.js
  const entries =
    {"main": `./${path.dev.js}/main.js`};

  return runWebPack({ entry: entries }, done);
});






//*------------------------------------*\
//     $SCRIPTS WATCH
//*------------------------------------*/
gulp.task('scripts:watch', ['scripts'],  () => global.browserSync.reload());





//*------------------------------------*\
//     $SCRIPTS VENDORS
//*------------------------------------*/
gulp.task('scripts:vendors', function(done) {});
  // entries =
  //   "vendor": "./#{path.dev.js}/vendor.js"

  // runWebPack(entries, {}, done)
  //





//*------------------------------------*\
//     $LINT
//*------------------------------------*/
gulp.task('scripts:lint',  function() {
  const files = [
    `${path.dev.js}/**/!(*.bundle).js`,
    `${path.dev.js}/**/*.jsx`
  ];

  return gulp.src(files)
    .pipe(eslint())
    .pipe(eslint.format());
});
