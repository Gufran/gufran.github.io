var gulp = require('gulp');
var uncss = require('gulp-uncss');
var glob = require('glob');
var concatCss = require('gulp-concat-css');
var prefixer = require('gulp-autoprefixer');
var csscomb = require('gulp-csscomb');
var minifyCSS = require('gulp-minify-css');
var minifyHTML = require('gulp-minify-html');
var htmlFiles = glob.sync('public/page*/**/*.html')
		         .concat(glob.sync('public/post*/**/*.html'))
		         .concat(glob.sync('public/tag*/**/*.html'))
		         .concat('public/index.html');

gulp.task('css', function () {
	gulp.src(['css/bootstrap.css', 'css/style.css', 'css/custom.css', 'css/icomoon.css', 'css/solarized.css'])
		.pipe(concatCss("style.css"))
		.pipe(prefixer({
			browsers: ['> 2%', 'last 3 versions', 'Firefox ESR', 'Opera 12.1']
		}))
		.pipe(uncss({
			html: htmlFiles
		}))
		.pipe(minifyCSS())
		.pipe(gulp.dest('css/build'))
});