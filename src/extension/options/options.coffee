###
options 选项
模块加载及路由
###

app = angular.module('cm', [
  'ui.bootstrap'
  'ui.router'
  'ngTouch'
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
    for k of TRANSLATIONS_ZH_CN
      if k not of TRANSLATIONS_EN
        TRANSLATIONS_EN[k] = k
    $translateProvider.translations('zh', TRANSLATIONS_ZH_CN)
      .translations('en', TRANSLATIONS_EN)
      .registerAvailableLanguageKeys(['zh', 'en'],
        'zh-cn': 'zh'
        'zh-tw': 'zh'
        'en': 'en'
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
  #when('/menu/:type', {
  #  templateUrl: 'partials/menu.html',
  #  controller: MenCtrl
  #}).
  #otherwise({
  #  redirectTo: '/about'
  #})
])
#$ ->
#  ga('send', 'event', 'i18n', navigator.language)
#  JU.syncFetch('/manifest.json', (result)->
#    ga('send', 'event', 'ver', JSON.parse(result).version)
#  )
#(->
#  code = JU.lsGet('locale', navigator.language.replace('-', '_'))
#  if code not in ['en', 'zh_CN', 'zh_TW']
#    code = 'en'
#  window.ci18n = new JU.I18n(code)
#)()
