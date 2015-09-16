###
# Settings controllers 控制器
###
SettingsCtrl = (scope, log, http, lsGetItem, lsSetItem)->
  ### 设置控制器 ###
  scope.lt1 = lsGetItem('lt1', '1')
  scope.lt2 = lsGetItem('lt2', '1')
  scope.rt1 = lsGetItem('rt1', '1')
  scope.rt2 = lsGetItem('rt2', '2')
  scope.lb1 = lsGetItem('lb1', '2')
  scope.lb2 = lsGetItem('lb2', '1')
  scope.rb1 = lsGetItem('rb1', '2')
  scope.rb2 = lsGetItem('rb2', '2')
  scope.$watch('lt1', (n, o)->
    lsSetItem('lt1', n)
  )
  scope.$watch('lt2', (n, o)->
    lsSetItem('lt2', n)
  )
  scope.$watch('rt1', (n, o)->
    lsSetItem('rt1', n)
  )
  scope.$watch('rt2', (n, o)->
    lsSetItem('rt2', n)
  )
  scope.$watch('lb1', (n, o)->
    lsSetItem('lb1', n)
  )
  scope.$watch('lb2', (n, o)->
    lsSetItem('lb2', n)
  )
  scope.$watch('rb1', (n, o)->
    lsSetItem('rb1', n)
  )
  scope.$watch('rb2', (n, o)->
    lsSetItem('rb2', n)
  )
  scope.i18n('settings')
  $('#i_help').html(ci18n.getMessage('i_help'))
  $('#i_help2').html(ci18n.getMessage('i_help2'))
  $('#h_drag').html(ci18n.getMessage('h_drag'))

  scope.qr_size = lsGetItem('qr_size', 250)
  scope.isEdit = lsGetItem('isEdit', true)
  scope.isFlag = lsGetItem('isFlag', true)
  scope.analytics = lsGetItem('analytics', true)
  scope.$watch('analytics',(n, o) ->
    lsSetItem('analytics', n)
    ga('send', 'event', 'settings', 'analytics' + n)
  )
  scope.$watch('isFlag',(n, o) ->
    lsSetItem('isFlag', n)
    ga('send', 'event', 'settings', 'isFlag' + n)
  )
  scope.$watch('isEdit',(n, o) ->
    lsSetItem('isEdit', n)
    ga('send', 'event', 'settings', 'isEdit' + n)
  )
  scope.back = lsGetItem('back', false)
  scope.newPage= lsGetItem('newPage', true)
  scope.alerts= []
  scope.phrase = lsGetItem('phrase', '')
  scope.all = []
  scope.init = ->
  scope.all = menuI18n(JU.lsGet('all',[]), [])
  scope.showName = (code)->
    ### 显示名称 ###
    for m in scope.all
      if m.c == code
        return m.n
    'None'
  scope.$watch('newPage',(n, o) ->
    lsSetItem('newPage', n)
  )
  scope.$watch('back',(n, o) ->
    lsSetItem('back', n)
  )
  scope.shorten = lsGetItem('shorten', 'googl')
  scope.$watch('shorten',(n, o) ->
    lsSetItem('shorten', n)
  )
  code = JU.lsGet('locale', navigator.language.replace('-', '_'))
  if code not in ['en', 'ru', 'zh_CN', 'zh_TW']
    code = 'en'
  scope.locale = lsGetItem('locale', code)
  scope.$watch('qr_size',(n, o) ->
    if scope.f_setting.$valid
      lsSetItem('qr_size', n)
  )
  scope.alert = (msg) ->
    ### 提示信息 ###
    scope.alerts.push(msg: msg)
  scope.closeAlert = (index) ->
    ### 删除提示信息 ###
    scope.alerts.splice(index, 1)
  scope.read = ->
    scope.bakstr = JSON.stringify(localStorage)
  # 加载2
  scope.load2 = ->
    if confirm(ci18n.getMessage('r_bak'))
      data = JSON.parse(scope.bakstr)
      for i of data
        localStorage[i] = data[i]
      scope.alert(ci18n.getMessage('b_load'))
      menuReset()
  scope.load = ->
    if scope.bak.$valid and confirm(ci18n.getMessage('r_bak'))
      http(
        method: 'POST'
        url: 'http://cm.xuender.me/cmget/'
        data: $.param(
          k: hex_sha1(scope.phrase)
        )
      ).success((data, status, headers, config) ->
        if data == 'error' or data == ''
          console.error 'load...%s', data
          return
        for i of data
          localStorage[i] = data[i]
        scope.alert(ci18n.getMessage('b_load'))
        menuReset()
        ga('send', 'event', 'bak', 'new_load')
      ).error((data, status, headers, config) ->
        scope.alert(ci18n.getMessage('error_ps'))
        ga('send', 'event', 'bak', 'new_error')
      )
  scope.save = (msg=true)->
    if scope.bak.$valid
      lsSetItem('phrase', scope.phrase)
      http(
        method: 'POST'
        url: 'http://cm.xuender.me/cmput/'
        data: $.param(
          k: hex_sha1(scope.phrase)
          v: JSON.stringify(localStorage)
        )
      ).success((data, status, headers, config) ->
        if 'ok' == data
          if msg
            scope.alert(ci18n.getMessage('b_save'))
            ga('send', 'event', 'bak', 'new_save')
      ).error((data, status, headers, config) ->
        scope.alert(ci18n.getMessage('error_ps'))
        ga('send', 'event', 'bak', 'new_error')
      )
  scope.$watch('locale', (n, o) ->
    lsSetItem('locale', n)
    window.ci18n = new JU.I18n(n)
    scope.i18n()
    menuReset()
  )
  scope.i18n = (key)->
    ci18n.getMessage(key)
  scope.init()
  log.debug('settings')
SettingsCtrl.$inject = ['$scope', '$log', '$http', 'lsGetItem', 'lsSetItem']
