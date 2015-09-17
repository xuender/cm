###
options 选项
模块加载及路由
###

app = angular.module('cm', [
  'ui.router'
  'pascalprecht.translate'
  'LocalStorageModule'
  'cm.controllers'
  #'search.directives'
  #'utils.directives'
  #'utils.services'
  #'ui.bootstrap'
])
ctrls = angular.module('cm.controllers', [])
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
    localStorageServiceProvider.setPrefix('cm')
    # 多国语言
    $translateProvider.translations('zh', TRANSLATIONS_ZH_CN)
      .translations('en', TRANSLATIONS_EN)
      .registerAvailableLanguageKeys(['zh', 'en'],
        'zh-cn': 'zh'
        'zh-tw': 'zh'
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
    )
  #when('/settings', {
  #  templateUrl: 'partials/settings.html',
  #  controller: SettingsCtrl
  #}).
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
