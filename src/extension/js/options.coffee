###
#options 选项
模块加载及路由
###
angular.module('search', [
  'ngRoute'
  'localytics.directives'
  'search.directives'
  'utils.directives'
  'utils.services'
  'ui.bootstrap'
]).config(['$routeProvider', ($routeProvider)->
  $routeProvider.
  when('/about', {
    templateUrl: 'partials/about.html',
    controller: AboutCtrl
  }).
  when('/menu/:type', {
    templateUrl: 'partials/menu.html',
    controller: MenCtrl
  }).
  when('/settings', {
    templateUrl: 'partials/settings.html',
    controller: SettingsCtrl
  }).
  otherwise({
    redirectTo: '/about'
  })
])
$ ->
  _gaq.push(['_trackEvent', 'i18n', navigator.language])
  JU.syncFetch('/manifest.json', (result)->
    _gaq.push(['_trackEvent', 'ver', JSON.parse(result).version])
  )
(->
  code = JU.lsGet('locale', navigator.language.replace('-', '_'))
  if code not in ['en', 'zh_CN', 'zh_TW']
    code = 'en'
  window.ci18n = new JU.I18n(code)
)()
