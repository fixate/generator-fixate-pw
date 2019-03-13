const gulp = require('gulp');
const gulpWatch = require('gulp-watch');

const conf = require('../gulpconfig');
const devPath = conf.path.dev;

require('./browser-sync');
require('./css');
require('./images');
require('./scripts');

/*------------------------------------*\
     $CSS WATCH
\*------------------------------------*/
const watch = gulp.task(
  'watch',
  gulp.series(
    gulp.parallel(
      'css:watch',
      'images:watch',
      'images:watch:svgpartials',
      'scripts:watch',
      'browser-sync',
    ),

    function watcher() {
      gulp.watch(`${conf.path.dev.scss}/**/*.scss`, gulp.series('css:watch'));
      gulp.watch(
        [
          `${conf.path.dev.js}/**/!(*.bundle).js`,
          `${conf.path.dev.js}/**/*.jsx`,
        ],
        gulp.series('scripts:lint', 'scripts:watch'),
      );
      gulp.watch(`${conf.path.dev.php}/**/*.php`, gulp.series('bs-reload'));
      gulp.watch(
        `${conf.path.dev.img}/raw/**/*.{jpeg,jpg,png,gif,svg,ico}`,
        gulp.series('images:watch'),
      );
      gulp.watch(
        `${conf.path.dev.img}/raw/svg/inline-icons/*.svg`,
        gulp.series('images:watch:inlinesvgicons'),
      );
      return gulp.watch(
        `${conf.path.dev.views}/partials/svg/raw/**/*.svg`,
        gulp.series('images:watch:svgpartials'),
      );
    },
  ),
);

/*------------------------------------*\
     $WATCH TESTS
\*------------------------------------*/
const watchTests = gulp.task('watch:tests', function() {
  gulp.watch([`${devPath.js}/**/*.js`]).on('change', file => {
    const basename = path.basename(file.path);
    const isTestFile = /_test/.test(basename);
    let testFile = file.path;

    if (isTestFile) {
      log(`Running ${basename}`);
    } else {
      try {
        const matchingTestFile = file.path.replace(/\.js$/, '_test.js');

        fs.accessSync(matchingTestFile, fs.F_OK);
        log(`Running ${path.basename(matchingTestFile)}`);
        testFile = matchingTestFile;
      } catch (e) {
        log(`No matching test file for ${basename}.`, 'red');
        log('Running all tests');
        testFile = `${devPath.assets}/**/*_test.js`;
      }
    }

    runTest(testFile);
  });

  function log(msg, color = 'green') {
    gutil.log(gutil.colors[color](msg));
  }

  function runTest(glob) {
    return gulp
      .src('./', {read: false})
      .pipe(shell(`$(which babel-tape-runner) ${glob} | faucet`))
      .on('error', () => {});
  }
});

module.exports = {watch, watchTests};
