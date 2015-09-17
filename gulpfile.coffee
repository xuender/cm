###
gulpfile.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
gulp = require 'gulp'
clean = require 'gulp-clean'
sass = require 'gulp-sass'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
usemin = require 'gulp-usemin'
uglify = require 'gulp-uglify'
minifyCss = require 'gulp-minify-css'
minifyHtml = require 'gulp-minify-html'
rev = require 'gulp-rev'
manifest = require 'gulp-chrome-manifest'
zip = require 'gulp-zip'
livereload = require 'gulp-livereload'
runSequence = require 'gulp-run-sequence'
karma = require('karma').server
jeditor = require 'gulp-json-editor'

Package = require './package.json'

gulp.task('clean', ->
  gulp.src([
    'dist'
  ], {read: false})
    .pipe(clean())
)

gulp.task('usemin', ->
  for s in ['about.html']
    gulp.src("src/extension/options/#{s}")
      .pipe(usemin({
        #css: minifyCss()
        #html: [minifyHtml({empty: true})],
        #js: uglify()
      }))
        .pipe(gulp.dest('dist/extension/options'))
  for s in ['options.html', 'popup.html']
    gulp.src("src/extension/#{s}")
      .pipe(usemin({
        #css: [minifyCss()],
        #css: [rev()],
        #html: [minifyHtml({empty: true})],
        #js: [uglify()],
      }))
        .pipe(gulp.dest('dist/extension'))
)

gulp.task('sass', ->
  gulp.src('src/extension/sass/options.sass')
    .pipe(sass(
      errLogToConsole: true
      indentedSyntax: true
    ))
    .pipe(gulp.dest('src/extension/css'))
)

gulp.task('copy', ->
  gulp.src([
    'src/extension/lib/oauth/chrome_ex_oauth.min.js'
    'src/extension/lib/*.min.js'
    'src/extension/lib/*.min.js'
  ])
    .pipe(gulp.dest('dist/lib'))
  gulp.src([
    'src/extension/*.json'
  ])
    .pipe(gulp.dest('dist/extension'))
  gulp.src([
    'src/extension/_locales/**'
  ])
    .pipe(gulp.dest('dist/extension/_locales'))
  gulp.src([
    'src/extension/img/**'
  ])
    .pipe(gulp.dest('dist/extension/img'))
  gulp.src([
    'src/extension/lib/bootstrap/fonts/*'
  ])
    .pipe(gulp.dest('dist/extension/fonts'))
  gulp.src([
    'src/extension/scripts/**'
  ])
    .pipe(gulp.dest('dist/extension/scripts'))
)

gulp.task('coffee', ->
  gulp.src([
    'src/extension/options/options.coffee'
    'src/extension/options/aboutCtrl.coffee'
  ])
    .pipe(coffee({bare:true}))
    .pipe(concat('options.js'))
    .pipe(gulp.dest('src/extension/js'))
  gulp.src([
    'src/extension/coffee/server.coffee'
  ])
    .pipe(coffee({bare:true}))
    .pipe(concat('server.js'))
    .pipe(gulp.dest('src/extension/js'))
  gulp.src([
    'src/extension/i18n/*.coffee'
  ])
    .pipe(coffee({bare:true}))
    .pipe(concat('i18n.js'))
    .pipe(gulp.dest('src/extension/js'))
  gulp.src([
    'src/extension/coffee/background.coffee'
  ])
    .pipe(coffee({bare:true}))
    .pipe(concat('background.js'))
    .pipe(gulp.dest('src/extension/js'))
)

gulp.task('manifest', ->
  gulp.src('src/extension/manifest.json')
    .pipe(jeditor((json)->
      json.version = Package.version
      json
    ))
    .pipe(manifest(
      buildnumber: true,
      exclude: [
        'key'
      ],
      #background:
      #  target: 'js/background.js',
      #  exclude: [
      #    'scripts/chromereload.js'
      #  ]
    ))
    .pipe(gulp.dest('dist/extension'))
)

gulp.task('zip', ->
  gulp.src('dist/extension/**')
    .pipe(zip("#{Package.name}-#{Package.version}.zip"))
    .pipe(gulp.dest('dist'))
)

gulp.task('watch', ->
  livereload.listen()
  gulp.watch(['src/**/*.scss', 'src/**/*.sass'], ['sass'])
  gulp.watch('src/**/*.coffee', ['coffee'])
  gulp.watch(['src/**/*.json', 'src/**/*.png'], ['copy'])
  gulp.watch('src/**/*.html', ['usemin'])
  #gulp.watch("src/**/*.html").on 'change', livereload.changed
  karma.start(
    configFile: __dirname + '/karma.conf.js',
  )
)

gulp.task('dev', (cb)->
  runSequence('clean', ['coffee', 'sass', 'copy'], 'usemin', cb)
)

gulp.task('dist', (cb)->
  runSequence('dev','manifest', 'zip', cb)
)

gulp.task('deploy', (cb)->
  runSequence('bump','dist', cb)
)

gulp.task('default', ['dev'])

