gulp = require('gulp')
gutil = require('gulp-util')
source = require('vinyl-source-stream')
buffer = require('vinyl-buffer')
watchify = require('watchify')
browserify = require('browserify')
stylus = require('gulp-stylus')
uglify = require('gulp-uglify')
streamify = require('gulp-streamify')

build_css = (src, outfile) ->
  gulp.src(src)
    .pipe(stylus())
    .pipe gulp.dest('public/')
  return

watch_css = (watch, src) ->
  gulp.watch watch, ->
    gulp.src(src)
      .pipe(stylus())
      .pipe gulp.dest('public/')
    return
  return

watch_bundler = (src, outfile) ->
  bundler = watchify(browserify(src,
    cache: {}
    packageCache: {}
    fullPaths: true))

  rebundle = ->
    bundler.bundle()
      .on('error', gutil.log.bind(gutil, 'Browserify Error'))
      .pipe(source(outfile))
      .pipe gulp.dest('./public')

  bundler.on 'update', rebundle
  bundler.transform 'coffee-reactify', extension: '.cjsx'
  rebundle()

build_browserify = (src, outfile) ->
  bundler = browserify(
    entries: src
    cache: {}
    packageCache: {}
    fullPaths: false
    debug: false)
  bundler.transform 'coffee-reactify', extension: '.cjsx'
  bundler.bundle()
    .pipe(source(outfile))
    .pipe(buffer())
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(streamify(uglify()))
    .pipe(gulp.dest('./public'))

gulp.task 'default', ->
  build_browserify './src/main.coffee', 'bundle.js'
  build_css [ './src/style/*.styl' ], 'src/style/main.styl'

gulp.task 'watch', ->
  watch_bundler './src/main.coffee', 'bundle.js'
  watch_css [ 'src/style/*.styl' ], 'src/style/main.styl'

