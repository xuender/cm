// Karma configuration
// Generated on Thu Dec 05 2013 14:44:43 GMT+0800 (CST)

module.exports = function(config) {
  config.set({

    // base path, that will be used to resolve files and exclude
    basePath: '',


    // frameworks to use
    frameworks: ['jasmine'],


    // list of files / patterns to load in the browser
    files: [
      //'bower_components/jquery/jquery.min.js',
      //'bower_components/angular-mocks/angular-mocks.js',
      //'bower_components/js-utils/js/js-utils.min.js',
      //'bower_components/js-utils/js/chrome.min.js',
      //'src/extension/js/ctrl/*.coffee',
      //'src/extension/coffee/lib/*.coffee',
      'src/extension/i18n/en.coffee',
      'src/extension/i18n/zh_CN.coffee',
      'src/extension/lib/jquery/dist/jquery.js',
      'src/extension/lib/bootstrap/dist/js/bootstrap.js',
      'src/extension/lib/angular/angular.js',
      'src/extension/lib/angular-bootstrap/ui-bootstrap-tpls.js',
      'src/extension/lib/angular-local-storage/dist/angular-local-storage.js',
      'src/extension/lib/angular-mocks/angular-mocks.js',
      'src/extension/options/options.coffee',
      'src/extension/options/i18nService.coffee',
      'test/**/*Spec.coffee'
    ],


    // list of files to exclude
    exclude: [
      
    ],


    preprocessors: {
      'test/**/*.coffee': ['coffee'],
      'src/**/*.coffee': ['coffee']
    },
    // test results reporter to use
    // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    //reporters: ['progress'],
    reporters: ['progress'],


    // web server port
    port: 9933,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera (has to be installed with `npm install karma-opera-launcher`)
    // - Safari (only Mac; has to be installed with `npm install karma-safari-launcher`)
    // - PhantomJS
    // - IE (only Windows; has to be installed with `npm install karma-ie-launcher`)
    //browsers: ['Chrome'],
    browsers: ['PhantomJS'],


    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 60000,


    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: false
  });
};
