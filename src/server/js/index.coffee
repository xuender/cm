###
# 网址列表
###
angular.module('urls', [
  'ui.bootstrap'
])

getSearch = ->
  # 查询参数 #
  ret = {}
  search = window.location.search[1..]
  if search[search.length - 1] == '/'
    search = search[..(search.length - 2)]
  for str in search.split('&')
    s = str.split('=')
    if s.length < 2
      ret[s[0]] = null
    else
      ret[s[0]] = s[1]
  ret

getType = ->
  ### 查询字符串 ###
  t = getSearch()['type']
  if t
    t = t.toUpperCase()
    if t in ['MEN', 'LIN', 'PIC', 'TXT']
      return t
  'TXT'

getLg = ->
  ### 查询字符串 ###
  lg = getSearch()['lg']
  if lg and lg in ['en', 'zh_CN', 'zh_TW', 'ru']
    return lg
  'en'
BodyCtrl = (scope, log, http)->
  scope.isShow = false
  scope.lg = getLg()
  scope._i18n = window[scope.lg]
  scope.getMessage = (key)->
    if scope._i18n
      if key of scope._i18n
        return scope._i18n[key].message
    key
  scope.i18n = ->
    for es in [$('span'), $('th'), $('button'), $('label')]
      for s in es
        if s.id
          s.textContent = scope.getMessage(s.id)
  scope.i18n()
  scope.locale =
    en: true
    zh_CN: true
    zh_TW: true
    ru: true
  scope.mode =
    TXT: false
    MEN: false
    PIC: false
    LIN: false
  scope.mode[getType()] = true
  scope.type = {}
  scope.typeValue = [
    'all'
    'new'
    'chrome'
    'pic'
    'ui'
    'mp3'
    'movie'
    'book'
    'fy'
    'comic'
    'shop'
    'sns'
    'utils'
  ]
  for t in scope.typeValue
    scope.type[t] = true
  scope.total = 50
  scope.numPages = 1
  scope.show = []
  scope.all = []

  scope.$watch('numPages',(n, o) ->
    if typeof scope.urls != 'undefined'
      scope.show = scope.urls[(n-1)*20..n*20]
  )
  scope.saved = false
  scope.$watch('saved',(n, o) ->
    scope.load()
    #lsSetItem('bl', n)
  )
  scope.$watch('locale',(n, o) ->
    scope.load()
    #lsSetItem('bl', n)
  , true)
  scope.$watch('mode',(n, o) ->
    scope.load()
    #lsSetItem('bl', n)
  , true)
  scope.$watch('type',(n, o) ->
    scope.load()
    #lsSetItem('bl', n)
  , true)

  isLocale = (u)->
    # 判断是否显示该语言
    u.l == 'all' or scope.locale[u.l]

  isMode = (u)->
    # 判断是否是该模式
    scope.mode[u.m]

  isType = (u)->
    # 判断是否是该类型 #
    scope.type[u.t]

  readIds = ()->
    # 设置使用过的ID #
    ids = JU.lsGet('ids', [])
    for i in scope.all
      i.o = false
    for id in ids
      for i in scope.all
        if i.c == id
          i.o = true

  scope.load = ->
    # 加载菜单
    readIds()
    scope.urls = []
    for u in scope.all
      b = isLocale(u)
      b = if b then isMode(u) else b
      b = if b then isType(u) else b
      if not scope.saved
        b = b and not u.o
      if b
        scope.urls.push(u)
    scope.total = scope.urls.length
    scope.numPages = 1
    scope.show = scope.urls[0..20]

  scope.init = ->
    scope.all = JSON.parse($('#all').val())

  scope.init()
  $(document).on('click', 'button', ->
    ga('send', 'event', 'server', $(this).text().trim())
    true
  )
  $(document).on('click', 'a', ->
    if $(this).attr('id')
      ga('send', 'event', 'server', $(this).attr('id'))
    true
  )
  scope.isShow = true
BodyCtrl.$inject = ['$scope', '$log', '$http']
