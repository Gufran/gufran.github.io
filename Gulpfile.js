const gulp       = require('gulp');
const glob       = require('glob');
const fs         = require('fs');
const concatCss  = require('gulp-concat-css');
const purgecss   = require('gulp-purgecss');
const cleanCss   = require('gulp-clean-css');
const htmlFiles  = glob.sync('docs/page*/**/*.html')
		         .concat(glob.sync('docs/post*/**/*.html'))
		         .concat(glob.sync('docs/tag*/**/*.html'))
		         .concat('docs/index.html');

const paths = {
    styles: {
        src: [
            'css/bootstrap.css',
            'css/style.css',
            'css/custom.css',
            'css/icomoon.css',
            'css/solarized.css'
        ],
        dest: 'css/build'
    }
}

function css() {
	return gulp.src(paths.styles.src)
		.pipe(concatCss("style.css"))
		.pipe(purgecss({
			content: htmlFiles
		}))
		.pipe(cleanCss())
		.pipe(gulp.dest(paths.styles.dest));
}

gulp.task('css', css);
