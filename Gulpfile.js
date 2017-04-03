const gulp = require('gulp');
const livescript = require('gulp-livescript');

gulp.task('compile-main', () => {
  return gulp.src('./src/*.ls')
        .pipe(livescript())
        .pipe(gulp.dest('./build'));
});

gulp.task('compile-commands', () => {
  return gulp.src('./src/cmd/*.ls')
        .pipe(livescript())
        .pipe(gulp.dest('./build/cmd'));
});

gulp.task('watch', () => {
  gulp.watch('./src/*.ls', ['compile-main']);
  gulp.watch('./src/cmd/*.ls', ['compile-commands']);
});

gulp.task('default', ['compile-commands', 'compile-main', 'watch']);
