var gulp = require('gulp');
var svgstore = require('gulp-svgstore');
var svgmin = require('gulp-svgmin');
//var path = require('path');
var inject = require('gulp-inject');
var cheerio = require('gulp-cheerio');
var path = require('../gulpconfig').path;
var gutil = require('gulp-util');

gulp.task('svg', function () {
    gutil.log(path.dev.icons + '/*.svg');
    var svgs = gulp
        .src(path.dev.icons + '/*.svg')
        .pipe(svgmin())
        .pipe(svgstore({fileName: 'icons.svg', inlineSvg: true})) // Diese Variante, wenn es inline verwendet werden soll
        .pipe(cheerio({
            run: function ($, file) {
                $('svg').addClass('hide');
                //$('[fill]').removeAttr('fill');
            },
            parserOptions: {xmlMode: true}
        }));

    function fileContents(filePath, file) {
        return file.contents.toString();
    }

    return gulp
        .src(path.dev.views + '/views/main.tpl')
        .pipe(inject(svgs, {transform: fileContents}))
        //.pipe(gulp.dest('src/site/templates/assets/img'));
        .pipe(gulp.dest(path.dev.views + '/views'));
});
