###
options 选项
模块加载及路由
###

app = angular.module('cm', [
  'ui.bootstrap'
  'ui.router'
  'ngTable'
  'pascalprecht.translate'
  'LocalStorageModule'
  'cm.controllers'
  'cm.services'
  'cm.directives'
  'utils.directives'
])
ctrls = angular.module('cm.controllers', [])
services = angular.module('cm.services', [])
utilsDirectives = angular.module('utils.directives', [])
app.config([
  '$stateProvider'
  '$urlRouterProvider'
  '$translateProvider'
  'localStorageServiceProvider'
  (
    $stateProvider
    $urlRouterProvider
    $translateProvider
    localStorageServiceProvider
  )->
    # 本地设置
    localStorageServiceProvider.setPrefix('')
    # 多国语言
    for k of TRANSLATIONS['zh_CN']
      for l in LANGUAGE
        if k not of TRANSLATIONS[l]
          TRANSLATIONS[l][k] = k
    for l in LANGUAGE
      $translateProvider.translations(l, TRANSLATIONS[l])
    $translateProvider.registerAvailableLanguageKeys(LANGUAGE,
        'zh-cn': 'zh_CN'
        'zh-tw': 'zh_TW'
        'en': 'en'
        'ru': 'ru'
      )
      .determinePreferredLanguage()
      .fallbackLanguage('en')
    $translateProvider.useSanitizeValueStrategy('escaped')
    # 路由
    $urlRouterProvider.otherwise("/about")
    $stateProvider.state('about',
      url: '/about'
      templateUrl: 'options/about.html'
      controller: 'AboutCtrl'
    ).state('settings',
      url: '/settings'
      templateUrl: 'options/settings.html',
      controller: 'SettingsCtrl'
    ).state('menu'
      url: '/menu/:type'
      templateUrl: 'options/menu.html',
      controller: 'MenuCtrl'
    )
])
