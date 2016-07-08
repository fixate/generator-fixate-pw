(function() {
  var assign, del, eslint, gulp, path, rename, runWebPack, webpack, webpackConf;

  gulp = require('gulp');

  assign = require('object.assign');

  eslint = require('gulp-eslint');

  webpack = require('webpack');

  rename = require('gulp-rename');

  del = require('del');

  path = require('../gulpconfig').path;

  webpackConf = require('../webpack.config.base');

  runWebPack = function(entries, config, done) {
    config = assign({
      entry: entries
    }, config, webpackConf);
    return webpack(config).run(function(err, stats) {
      if (err) {
        console.log('Error', err);
      } else {
        console.log(stats.toString({
          chunks: false
        }));
        done();
      }
    });
  };

  gulp.task('scripts', function(done) {
    var entries;
    del([path.prod.js + '**']);
    entries = {
      "main": ["./" + path.dev.js + "/main.js"]
    };
    return runWebPack(entries, {}, done);
  });

  gulp.task('scripts:vendors', function(done) {});

  gulp.task('scripts:lint', function() {
    var files;
    files = [path.dev.js + "/**/!(*.bundle).js", path.dev.js + "/**/*.jsx"];
    return gulp.src(files).pipe(eslint()).pipe(eslint.format('node_modules/eslint-formatter-pretty'));
  });

}).call(this);
