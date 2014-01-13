module.exports = (grunt)->
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-karma')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-htmlmin')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-bumpx')
  grunt.loadNpmTasks('grunt-contrib-compress')
  grunt.loadNpmTasks('grunt-manifest')

  grunt.initConfig(
    pkg:
      grunt.file.readJSON('package.json')
    clean:
      dist: ['dist']
    bump:
      options:
        part: 'patch'
      files: [ 'package.json', 'src/extension/manifest.json' ]
    copy:
      oauth:
        files: [
          cwd: 'src/extension/lib/oauth/'
          src: [
            'chrome_ex_oauth.min.js'
          ]
          dest: 'dist/extension/js'
          expand: true
          filter: 'isFile'
        ]
      qrcode:
        files: [
          cwd: 'src/extension/lib/'
          src: [
            'qrcode.min.js'
          ]
          dest: 'dist/extension/js'
          expand: true
          filter: 'isFile'
        ]
      angular:
        files: [
          cwd: 'bower_components/angular/'
          src: [
            'angular.min.js'
            'angular.min.js.map'
          ]
          dest: 'dist/extension/js'
          expand: true
          filter: 'isFile'
        ]
      angularServer:
        files: [
          cwd: 'bower_components/angular/'
          src: [
            'angular.min.js'
            'angular.min.js.map'
          ]
          dest: 'dist/server/js'
          expand: true
          filter: 'isFile'
        ]
      angularRoute:
        files: [
          cwd: 'bower_components/angular-route/'
          src: [
            'angular-route.min.js'
            'angular-route.min.js.map'
          ]
          dest: 'dist/extension/js'
          expand: true
          filter: 'isFile'
        ]
      chosen:
        files: [
          cwd: 'src/extension/lib/'
          src: [
            'chosen.jquery.min.js'
          ]
          dest: 'dist/extension/js'
          expand: true
          filter: 'isFile'
        ]
      angularBootstrap:
        files: [
          cwd: 'bower_components/angular-bootstrap/'
          src: [
            'ui-bootstrap-tpls.min.js'
          ]
          dest: 'dist/extension/js'
          expand: true
          filter: 'isFile'
        ]
      angularBootstrapServer:
        files: [
          cwd: 'bower_components/angular-bootstrap/'
          src: [
            'ui-bootstrap-tpls.min.js'
          ]
          dest: 'dist/server/js'
          expand: true
          filter: 'isFile'
        ]
      jquery:
        files: [
          cwd: 'bower_components/jquery/'
          src: [
            'jquery.min.js'
            'jquery.min.map'
          ]
          dest: 'dist/extension/js'
          expand: true
          filter: 'isFile'
        ]
      jqueryServer:
        files: [
          cwd: 'bower_components/jquery/'
          src: [
            'jquery.min.js'
            'jquery.min.map'
          ]
          dest: 'dist/server/js'
          expand: true
          filter: 'isFile'
        ]
      bootstrap:
        files: [
          cwd: 'bower_components/bootstrap/dist/'
          src: [
            'css/bootstrap.min.css'
            'js/bootstrap.min.js'
            'fonts/*'
          ]
          dest: 'dist/extension'
          expand: true
          filter: 'isFile'
        ]
      bootstrapServer:
        files: [
          cwd: 'bower_components/bootstrap/dist/'
          src: [
            'css/bootstrap.min.css'
            'js/bootstrap.min.js'
            'fonts/*'
          ]
          dest: 'dist/server'
          expand: true
          filter: 'isFile'
        ]
      utils:
        files: [
          cwd: 'bower_components/js-utils/js/'
          src: [
            'iconv.min.js'
            'js-utils.min.js'
            'chrome.min.js'
          ]
          dest: 'dist/extension/js'
          expand: true
          filter: 'isFile'
        ]
      root:
        files: [
          cwd: 'src/extension'
          src: [
            'manifest.json'
            'init.json'
          ]
          dest: 'dist/extension'
          expand: true
          filter: 'isFile'
        ]
      i18n:
        files: [
          cwd: 'src/extension'
          src: '_locales/**'
          dest: 'dist/extension'
          expand: true
          filter: 'isFile'
        ]
      i18nServer:
        files: [
          cwd: 'src/server'
          src: '_locales/**'
          dest: 'dist/server'
          expand: true
          filter: 'isFile'
        ]
      img:
        files: [
          cwd: 'src/extension'
          src: 'img/**'
          dest: 'dist/extension'
          expand: true
          filter: 'isFile'
        ]
      html5:
        files: [
          cwd: 'bower_components/js-utils'
          src: 'js/chrome.min.js'
          dest: 'dist/server'
          expand: true
          filter: 'isFile'
        ]
      jsonServer:
        files: [
          cwd: 'src/server'
          src: 'a.json'
          dest: 'dist/server'
          expand: true
          filter: 'isFile'
        ]
      imgServer:
        files: [
          cwd: 'src/extension'
          src: 'img/**'
          dest: 'dist/server'
          expand: true
          filter: 'isFile'
        ]
    coffee:
      options:
        bare: true
      context:
        files:
          'dist/extension/js/context.js': [
            'src/extension/js/context.coffee'
          ]
      components:
        files:
          'dist/extension/js/components.min.js': [
            'src/extension/js/db.coffee'
            'src/extension/js/lib/analytics.coffee'
          ]
      background:
        files:
          'dist/extension/js/background.min.js': [
            'src/extension/js/coden.coffee'
            'src/extension/js/tools.coffee'
            'src/extension/js/bg_server.coffee'
            'src/extension/js/background.coffee'
          ]
      optionJs:
        files:
          'dist/extension/js/options.min.js': [
            'src/extension/lib/chosen.coffee'
            'src/extension/js/lib/utilServices.coffee'
            'src/extension/js/lib/utilDirectives.coffee'
            'src/extension/js/lib/directives.coffee'
            'src/extension/js/ctrl/bodyCtrl.coffee'
            'src/extension/js/ctrl/aboutCtrl.coffee'
            'src/extension/js/ctrl/menCtrl.coffee'
            'src/extension/js/ctrl/editCtrl.coffee'
            'src/extension/js/ctrl/putCtrl.coffee'
            'src/extension/js/ctrl/settingsCtrl.coffee'
            'src/extension/js/options.coffee'
          ]
      popup:
        files:
          'dist/extension/js/popup.min.js': [
            'src/extension/js/lib/utilServices.coffee'
            'src/extension/js/lib/utilDirectives.coffee'
            'src/extension/js/ctrl/popupCtrl.coffee'
            'src/extension/js/popup.coffee'
          ]
      server:
        files:
          'dist/extension/js/server.min.js': [
            'src/extension/js/server.coffee'
          ]
      index:
        files:
          'dist/server/js/index.min.js': [
            'src/server/js/index.coffee'
          ]
    uglify:
      components:
        files:
          'dist/extension/js/components.min.js': [
            'dist/extension/js/components.min.js'
          ]
      optionJs:
        files:
          'dist/extension/js/options.min.js': [
            'dist/extension/js/options.min.js'
          ]
      popupJs:
        files:
          'dist/extension/js/popup.min.js': [
            'dist/extension/js/popup.min.js'
          ]
      background:
        files:
          'dist/extension/js/background.min.js': [
            'dist/extension/js/background.min.js'
          ]
      index:
        files:
          'dist/server/js/index.min.js': [
            'dist/server/js/index.min.js'
          ]
    htmlmin:
      dist:
        options:
          removeComments: true,
          collapseWhitespace: true
        files:
          'dist/extension/popup.html': 'src/extension/popup.html'
          'dist/extension/options.html': 'src/extension/options.html'
          'dist/extension/partials/about.html': 'src/extension/partials/about.html'
          'dist/extension/partials/editMenu.html': 'src/extension/partials/editMenu.html'
          'dist/extension/partials/menu.html': 'src/extension/partials/menu.html'
          'dist/extension/partials/putUrl.html': 'src/extension/partials/putUrl.html'
          'dist/extension/partials/settings.html': 'src/extension/partials/settings.html'
          'dist/server/index.html': 'src/server/index.html'
    cssmin:
      cm:
        expand: true
        cwd: 'src/extension/css/'
        src: ['*.css', '!*.min.css'],
        dest: 'dist/extension/css/',
        ext: '.min.css'
      cmServer:
        expand: true
        cwd: 'src/server/css/'
        src: ['*.css', '!*.min.css'],
        dest: 'dist/server/css/',
        ext: '.min.css'
    watch:
      json:
        files: [
          'src/**/*.json'
        ]
        tasks: [
          'copy:root'
          'copy:i18n'
          'copy:i18nServer'
        ]
      html:
        files: [
          'src/**/*.html'
        ]
        tasks: ['htmlmin']
      css:
        files: [
          'src/**/*.css'
        ]
        tasks: ['cssmin']
      coffee:
        files: [
          'src/**/*.coffee'
        ]
        tasks: ['coffee']
    compress:
      google:
        options:
          archive: 'dist/cm.zip'
        files: [
          {expand: true, cwd: 'dist/extension/', src: '**/*', dest: '/'}
        ]
    karma:
      options:
        configFile: 'karma.conf.js'
      dev:
        colors: true,
      travis:
        singleRun: true
        autoWatch: false
    manifest:
      server:
        options:
          basePath: '../'
          cache: [
            '../css/bootstrap.min.css'
            '../css/index.min.css'
            '../js/jquery.min.js'
            '../js/chrome.min.js'
            '../js/index.min.js'
            '../js/ui-bootstrap-tpls.min.js'
            '../js/angular.min.js'
            '../img/en.png'
            '../img/zh_CN.png'
            '../img/zh_TW.png'
            '../img/ru.png'
            '../_locales/zh_CN/messages.json'
            '../_locales/zh_TW/messages.json'
            '../_locales/en/messages.json'
            '../_locales/ru/messages.json'
            '../fonts/glyphicons-halflings-regular.woff'
            '../js/jquery.min.map'
            '../js/angular.min.js.map'
          ]
        src: [
        ]
        dest: 'dist/server/manifest.appcache'
  )
  grunt.registerTask('test', ['karma'])
  grunt.registerTask('dev', [
    'clean'
    'copy',
    'htmlmin'
    'cssmin'
    'coffee'
    'manifest'
  ])
  grunt.registerTask('dist', [
    'dev'
    'uglify'
    'compress'
  ])
  grunt.registerTask('deploy', [
    'dist'
    'bump'
  ])
  grunt.registerTask('default', ['dist'])
