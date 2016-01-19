/**
 * Created by Red on 2016/1/18.
 */
//gulpfile.js
var gulp = require('gulp'),
    coffee = require('gulp-coffee');

gulp.task('coffee', function() {
    gulp.src('./app/coffeescripts/*.coffee')
        .pipe(coffee())
        .pipe(gulp.dest('./app/assets/js'));
});