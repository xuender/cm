###
# 网址列表
###
angular.module('urls', [
  'ui.bootstrap'
])

BodyCtrl = (scope, log)->
  scope.locale =
    en: true
    zh_CN: true
    zh_TW: true
    ru: true
  scope.mode =
    TXT: true
    MEN: false
    PIC: false
    LIN: false
  scope.total = 50
  scope.page = 1
  scope.numPages = 1
  scope.show = []
  scope.$watch('numPages',(n, o) ->
    scope.show = scope.urls[n*20..n*20+20]
  )
  scope.$watch('locale',(n, o) ->
    scope.load()
    #lsSetItem('bl', n)
  , true)
  scope.$watch('mode',(n, o) ->
    console.info scope.mode
    scope.load()
    #lsSetItem('bl', n)
  , true)
  isLocale = (u)->
    # 判断是否显示该语言
    u.l == 'all' or scope.locale[u.l]
  isMode = (u)->
    # 判断是否是该模式
    scope.mode[u.m]
  scope.load = ->
    # 加载菜单
    scope.urls = []
    for u in URL
      b = isLocale(u)
      if b
        b = isMode(u)
      if b
        scope.urls.push(u)
    scope.total = scope.urls.length
    scope.page = 1
    scope.show = scope.urls[0..20]
  scope.load()
BodyCtrl.$inject = ['$scope', '$log']
