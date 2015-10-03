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
#sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
minifyCss = require 'gulp-minify-css'
minifyHtml = require 'gulp-minify-html'
rev = require 'gulp-rev'
manifest = require 'gulp-chrome-manifest'
zip = require 'gulp-zip'
livereload = require 'gulp-livereload'
sequence = require 'gulp-sequence'
karma = require('karma').server
jeditor = require 'gulp-json-editor'
bump = require 'gulp-bump'
jsoncombine = require("gulp-jsoncombine")

Package = require './package.json'
dev = false

gulp.task('clean', ->
  gulp.src([
    'dist'
    'src/extension/js'
    'src/extension/css'
  ], {read: false})
    .pipe(clean())
)

gulp.task('usemin1', ->
  gulp.src("./src/extension/options/*.html")
    .pipe(usemin({
      #css: minifyCss()
      html:  [ ->
        minifyHtml({ empty: true })
      ]
      #js: uglify()
    }))
      .pipe(gulp.dest('dist/extension/options/'))
)

gulp.task('usemin2', ->
  gulp.src("src/extension/*.html")
    .pipe(usemin({
      html:  [ ->
        minifyHtml({ empty: true })
      ]
      #css: [minifyCss()],
      #js: [uglify()],
    }))
      .pipe(gulp.dest('dist/extension'))
)

gulp.task('usemin', sequence(['usemin1','usemin2']))

gulp.task('sass', ->
  gulp.src(['src/extension/popup/popup.sass', 'src/extension/options/options.sass'])
    .pipe(sass(
      errLogToConsole: true
      indentedSyntax: true
      outputStyle: 'compressed'
    ))
    .pipe(gulp.dest('src/extension/css'))
)

gulp.task('copy1', ->
  gulp.src([
    'src/extension/js/background.js'
    'src/extension/js/bg_lib.js'
    'src/extension/js/i18n.js'
  ])
    .pipe(gulp.dest('dist/extension/js'))
)
gulp.task('copy2', ->
  gulp.src([
    'src/extension/*.json'
  ])
    .pipe(gulp.dest('dist/extension'))
)
gulp.task('copy3', ->
  gulp.src([
    'src/extension/_locales/**'
  ])
    .pipe(gulp.dest('dist/extension/_locales'))
)
gulp.task('copy4', ->
  gulp.src([
    'src/extension/img/**'
  ])
    .pipe(gulp.dest('dist/extension/img'))
)
gulp.task('copy5', ->
  gulp.src([
    'src/extension/lib/bootstrap/fonts/*'
  ])
    .pipe(gulp.dest('dist/extension/fonts'))
)
gulp.task('copy6', ->
  gulp.src([
    'src/extension/lib/chosen/*.png'
  ])
    .pipe(gulp.dest('dist/extension/css'))
)
gulp.task('copy', sequence(['copy1', 'copy2', 'copy3', 'copy4', 'copy5', 'copy6']))

gulp.task('concat', ->
  gulp.src([
    'src/extension/lib/js-utils/js/ionic.min.js'
    'src/extension/scripts/chrome_ex_oauth.min.js'
    'src/extension/lib/js-utils/js/chrome.min.js'
    'src/extension/lib/js-utils/js/js-utils.min.js'
    'src/extension/scripts/qrcode.min.js'
  ])
    .pipe(concat('bg_lib.js'))
    .pipe(gulp.dest('src/extension/js'))
)

gulp.task('test', ->
  karma.start(
    configFile: __dirname + '/karma.conf.js',
    singleRun: true
  )
)

gulp.task('coffee1', ->
  t = gulp.src([
    'src/extension/scripts/analytics.coffee'
    'src/extension/popup/popup.coffee'
    'src/extension/popup/popupCtrl.coffee'
    'src/extension/scripts/utilDirectives.coffee'
  ])
    .pipe(coffee({bare:true}))
    .pipe(concat('popup.js'))
  if dev
    t.pipe(uglify())
  t.pipe(gulp.dest('src/extension/js'))
)
gulp.task('coffee2', ->
  t = gulp.src([
    'src/extension/scripts/analytics.coffee'
    'src/extension/options/options.coffee'
    'src/extension/options/chosen.coffee'
    'src/extension/options/optionsCtrl.coffee'
    'src/extension/options/menuCtrl.coffee'
    'src/extension/options/menusCtrl.coffee'
    'src/extension/options/putCtrl.coffee'
    'src/extension/options/editCtrl.coffee'
    'src/extension/options/putCtrl.coffee'
    'src/extension/options/aboutCtrl.coffee'
    'src/extension/options/settingsCtrl.coffee'
    'src/extension/scripts/utilDirectives.coffee'
    'src/extension/options/menuService.coffee'
    'src/extension/options/dialogService.coffee'
    'src/extension/options/i18nService.coffee'
    'src/extension/options/directives.coffee'
  ])
    .pipe(coffee({bare:true}))
    .pipe(concat('options.js'))
  if dev
    t.pipe(uglify())
  t.pipe(gulp.dest('src/extension/js'))
)
gulp.task('coffee3', ->
  t = gulp.src([
    'src/extension/i18n/*.coffee'
  ])
    .pipe(coffee({bare:true}))
    .pipe(concat('i18n.js'))
  if dev
    t.pipe(uglify())
  t.pipe(gulp.dest('src/extension/js'))
)
gulp.task('coffee4', ->
  t = gulp.src([
    'src/extension/background/code.coffee'
    'src/extension/background/tools.coffee'
    'src/extension/background/background.coffee'
    'src/extension/scripts/analytics.coffee'
    #'src/extension/background/chromereload.coffee' # 正式发布需要删除这行
  ])
    .pipe(coffee({bare:true}))
    .pipe(concat('background.js'))
  if dev
    t.pipe(uglify())
  t.pipe(gulp.dest('src/extension/js'))
)

gulp.task('coffee', (cb)->
  sequence(['coffee1','coffee2', 'coffee3', 'coffee4'], cb)
)

gulp.task('manifest', ->
  gulp.src('src/extension/manifest.json')
    .pipe(jeditor((json)->
      json.version = Package.version
      json
    ))
    .pipe(manifest(
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
  Package = require './package.json'
  gulp.src('dist/extension/**')
    .pipe(zip("#{Package.name}-#{Package.version}.zip"))
    .pipe(gulp.dest('dist'))
)

gulp.task('watch', ->
  livereload.listen()
  gulp.watch(['src/**/*.scss', 'src/**/*.sass'], ['sass'])
  gulp.watch('src/**/*.coffee', ['coffee'])
  #gulp.watch(['src/**/*.json', 'src/**/*.png'], ['copy'])
  #gulp.watch('src/**/*.html', ['usemin'])
  #gulp.watch("src/**/*.html").on 'change', livereload.changed
  karma.start(
    configFile: __dirname + '/karma.conf.js',
  )
)

gulp.task('bump', ->
  gulp.src(['./bower.json', './package.json'])
    .pipe(bump({type:'patch'}))
    .pipe(gulp.dest('./'))
)

gulp.task('dev', (cb)->
  dev = true
  sequence('clean', ['coffee', 'concat'], ['sass', 'copy'], 'usemin', cb)
)

gulp.task('dist', sequence('dev','manifest', 'zip'))

gulp.task('deploy', sequence('bump','dist'))

gulp.task('default', ['dev'])

