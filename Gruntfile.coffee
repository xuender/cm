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

  grunt.initConfig(
    pkg:
      # 读取配置
      grunt.file.readJSON('package.json')
    clean:
      # 清除临时目录
      dist: ['dist', 'cms_dist']
    bump:
      # 版本修改
      options:
        part: 'patch'
      files: [ 'package.json', 'src/manifest.json' ]
    copy:
      angular:
        files: [
          cwd: 'bower_components/angular/'
          src: [
            'angular.min.js'
            'angular.js'
            'angular.min.js.map'
          ]
          dest: 'dist/js'
          expand: true
          filter: 'isFile'
        ]
      angularCms:
        files: [
          cwd: '<%= copy.angular.files.0.cwd %>'
          src: '<%= copy.angular.files.0.src %>'
          dest: 'cms_dist/js'
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
          dest: 'dist/js'
          expand: true
          filter: 'isFile'
        ]
      angularBootstrap:
        files: [
          cwd: 'bower_components/angular-bootstrap/'
          src: [
            'ui-bootstrap-tpls.min.js'
          ]
          dest: 'dist/js'
          expand: true
          filter: 'isFile'
        ]
      angularBootstrapCms:
        files: [
          cwd: '<%= copy.angularBootstrap.files.0.cwd %>'
          src: '<%= copy.angularBootstrap.files.0.src %>'
          dest: 'cms_dist/js'
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
          dest: 'dist/js'
          expand: true
          filter: 'isFile'
        ]
      jqueryCms:
        files: [
          cwd: '<%= copy.jquery.files.0.cwd %>'
          src: '<%= copy.jquery.files.0.src %>'
          dest: 'cms_dist/js'
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
          dest: 'dist'
          expand: true
          filter: 'isFile'
        ]
      fontCms:
        # font-awesome
        files: [
          cwd: '<%= copy.font.files.0.cwd %>'
          src: '<%= copy.font.files.0.src %>'
          dest: 'cms_dist'
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
          dest: 'dist'
          expand: true
          filter: 'isFile'
        ]
      bootstrapCms:
        # bootstrap 2.3.2
        files: [
          cwd: '<%= copy.bootstrap.files.0.cwd %>'
          src: '<%= copy.bootstrap.files.0.src %>'
          dest: 'cms_dist'
          expand: true
          filter: 'isFile'
        ]
      utils:
        files: [
          cwd: 'bower_components/js-utils/js/'
          src: [
            'js-utils.min.js'
            'chrome.min.js'
          ]
          dest: 'dist/js'
          expand: true
          filter: 'isFile'
        ]
      root:
        files: [
          cwd: 'src/'
          src: ['manifest.json']
          dest: 'dist'
          expand: true
          filter: 'isFile'
        ]
      i18n:
        files: [
          cwd: 'src/'
          src: '_locales/**'
          dest: 'dist'
          expand: true
          filter: 'isFile'
        ]
      img:
        files: [
          cwd: 'src/'
          src: 'img/**'
          dest: 'dist'
          expand: true
          filter: 'isFile'
        ]
      imgCms:
        files: [
          cwd: 'src/'
          src: 'img/**'
          dest: 'cms_dist'
          expand: true
          filter: 'isFile'
        ]

    coffee:
      # 合并多个文件
      #      'bower_components/angular-chosen-localytics/chosen.js'
      options:
        bare: true
      components:
        files:
          'dist/js/components.min.js': [
            'src/js/lib/analytics.coffee'
            'src/js/db.coffee'
          ]
      background:
        files:
          'dist/js/background.min.js': [
            'src/js/background.coffee'
          ]
      optionJs:
        files:
          'dist/js/options.min.js': [
            'src/js/lib/utilServices.coffee'
            'src/js/lib/utilDirectives.coffee'
            'src/js/lib/directives.coffee'
            'src/js/ctrl/bodyCtrl.coffee'
            'src/js/ctrl/aboutCtrl.coffee'
            'src/js/ctrl/menCtrl.coffee'
            'src/js/ctrl/editCtrl.coffee'
            'src/js/ctrl/putCtrl.coffee'
            'src/js/ctrl/settingsCtrl.coffee'
            'src/js/options.coffee'
          ]
      index:
        files:
          'cms_dist/js/index.min.js': [
            'cms_src/js/index.coffee'
            'cms_src/js/init.coffee'
          ]
    uglify:
      # 压缩js
      components:
        files:
          'dist/js/components.min.js': [
            'dist/js/components.min.js'
          ]
      optionJs:
        files:
          'dist/js/options.min.js': [
            'dist/js/options.min.js'
          ]
      background:
        files:
          'dist/js/background.min.js': [
            'dist/js/background.min.js'
          ]
    htmlmin:
      # 压缩HTML
      dist:
        options:
          removeComments: true,
          collapseWhitespace: true
        files:
          'dist/popup.html': 'src/popup.html'
          'dist/options.html': 'src/options.html'
          'dist/partials/about.html': 'src/partials/about.html'
          'dist/partials/editMenu.html': 'src/partials/editMenu.html'
          'dist/partials/menu.html': 'src/partials/menu.html'
          'dist/partials/putUrl.html': 'src/partials/putUrl.html'
          'dist/partials/settings.html': 'src/partials/settings.html'
          'cms_dist/index.html': 'cms_src/index.html'
    cssmin:
      # css压缩
      cm:
        expand: true
        cwd: 'src/css/'
        src: ['*.css', '!*.min.css'],
        dest: 'dist/css/',
        ext: '.min.css'
      cms:
        expand: true
        cwd: 'cms_src/css/'
        src: ['*.css', '!*.min.css'],
        dest: 'cms_dist/css/',
        ext: '.min.css'
    watch:
      html:
        files: [
          'src/**/*.html'
          'src/*.html'
          'cms_src/*.html'
        ]
        tasks: ['htmlmin']
      css:
        files: [
          'src/css/*.css'
          'cms_src/css/*.css'
        ]
        tasks: ['cssmin']
      coffee:
        files: [
          'src/js/*.coffee'
          'src/js/ctrl/*.coffee'
          'cms_src/js/*.coffee'
        ]
        tasks: ['coffee']
    karma:
      # karma 测试
      options:
        configFile: 'karma.conf.js'
      dev:
        colors: true,
      travis:
        singleRun: true
        autoWatch: false
  )
  grunt.registerTask('test', '测试', ['karma'])
  grunt.registerTask('dev', '开发数据', [
    'clean'
    'copy',
    'htmlmin'
    'cssmin'
    'coffee'
  ])
  grunt.registerTask('dist', '打包', [
    'dev'
    'uglify'
  ])
  grunt.registerTask('deploy', '发布', [
    'dist'
    'bump'
  ])
  grunt.registerTask('default', '默认(打包)', ['dist'])
