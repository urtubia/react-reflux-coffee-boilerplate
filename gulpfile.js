var gulp = require('gulp');
var gutil = require('gulp-util');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');
var watchify = require('watchify');
var browserify = require('browserify');
var stylus = require('gulp-stylus');
var uglify = require('gulp-uglify');
var streamify = require('gulp-streamify');

function build_css(src, outfile){
  gulp.src(src)
  .pipe(stylus())
  .pipe(gulp.dest('public/'));
}

function watch_css(watch,src){
  gulp.watch(watch,function(){
    gulp.src(src)
    .pipe(stylus())
    .pipe(gulp.dest('public/'));
  });
}

function watch_bundler(src, outfile){
  var bundler = watchify(browserify(src, {
    cache: {},
    packageCache: {},
    fullPaths: true,
  }));

  bundler.on('update', rebundle);
  bundler.transform('coffee-reactify', { extension: ".cjsx"});

  function rebundle() {
    return bundler.bundle()
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(source(outfile))
    .pipe(gulp.dest('./public'));
  }

  return rebundle();
}

function build_browserify(src, outfile){
  var bundler = browserify({
    entries: src,
    cache: {},
    packageCache: {},
    fullPaths: false,
    debug: false,
  });
  bundler.transform('coffee-reactify', { extension: ".cjsx"});
  return bundler.bundle()
  .pipe(source(outfile))
  .pipe(buffer())
  .on('error', gutil.log.bind(gutil, 'Browserify Error'))
  .pipe(streamify(uglify()))
  .pipe(gulp.dest('./public'));
}

gulp.task('default', function(){
  watch_bundler('./src/main.coffee','bundle.js');
  watch_css(['src/style/*.styl'], 'src/style/main.styl');
});

gulp.task('production', function(){
  build_browserify('./src/main.coffee', 'bundle.js');
  build_css(['./src/style/*.styl'],'src/style/main.styl');
});
