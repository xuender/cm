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
          cwd: 'src/extension/lib/angular/'
          src: [
            'angular.min.js'
          ]
          dest: 'dist/extension/js'
          expand: true
          filter: 'isFile'
        ]
      angularServer:
        files: [
          cwd: '<%= copy.angular.files.0.cwd %>'
          src: '<%= copy.angular.files.0.src %>'
          dest: 'dist/server/js'
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
          cwd: '<%= copy.angularBootstrap.files.0.cwd %>'
          src: '<%= copy.angularBootstrap.files.0.src %>'
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
          cwd: '<%= copy.jquery.files.0.cwd %>'
          src: '<%= copy.jquery.files.0.src %>'
          dest: 'dist/server/js'
          expand: true
          filter: 'isFile'
        ]
      font:
        # font-awesome
        files: [
          cwd: 'bower_components/font-awesome/'
          src: [
            'css/font-awesome.min.css'
            'fonts/fontawesome-webfont.eot'
            'fonts/fontawesome-webfont.svg'
            'fonts/fontawesome-webfont.ttf'
            'fonts/fontawesome-webfont.woff'
          ]
          dest: 'dist/extension'
          expand: true
          filter: 'isFile'
        ]
      fontServer:
        # font-awesome
        files: [
          cwd: '<%= copy.font.files.0.cwd %>'
          src: '<%= copy.font.files.0.src %>'
          dest: 'dist/server'
          expand: true
          filter: 'isFile'
        ]
      bootstrap:
        # bootstrap 2.3.2
        files: [
          cwd: 'bower_components/bootstrap/bootstrap/'
          src: [
            'css/bootstrap.min.css'
            'js/bootstrap.min.js'
          ]
          dest: 'dist/extension'
          expand: true
          filter: 'isFile'
        ]
      bootstrapServer:
        # bootstrap 2.3.2
        files: [
          cwd: '<%= copy.bootstrap.files.0.cwd %>'
          src: '<%= copy.bootstrap.files.0.src %>'
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
      img:
        files: [
          cwd: 'src/extension'
          src: 'img/**'
          dest: 'dist/extension'
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
      index:
        files:
          'dist/server/js/index.min.js': [
            'src/server/js/index.coffee'
            'src/server/js/init.coffee'
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
  )
  grunt.registerTask('test', ['karma'])
  grunt.registerTask('dev', [
    'clean'
    'copy',
    'htmlmin'
    'cssmin'
    'coffee'
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
