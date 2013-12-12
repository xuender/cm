###
# Settings controllers 控制器
###
SettingsCtrl = (scope, log, http, lsGetItem, lsSetItem)->
  ### 设置控制器 ###
  scope.i18n('settings')
  $('#i_help').html(ci18n.getMessage('i_help'))
  $('#i_help2').html(ci18n.getMessage('i_help2'))

  scope.qr_size = lsGetItem('qr_size', 250)
  scope.isEdit = lsGetItem('isEdit', true)
  scope.isFlag = lsGetItem('isFlag', true)
  scope.$watch('isFlag',(n, o) ->
    lsSetItem('isFlag', n)
    _gaq.push(['_trackEvent', 'settings', 'isFlag' + n])
  )
  scope.$watch('isEdit',(n, o) ->
    lsSetItem('isEdit', n)
    _gaq.push(['_trackEvent', 'settings', 'isEdit' + n])
  )
  scope.back = lsGetItem('back', false)
  scope.drag = lsGetItem('drag', false)
  scope.newPage= lsGetItem('newPage', true)
  scope.alerts= []
  scope.phrase = lsGetItem('phrase', '')
  scope.bl = []
  scope.all = []
  scope.init = ->
    findUrls((data)->
      scope.all = menuI18n(data, [])
      scope.bl = lsGetItem('bl', [])
      scope.$apply()
      scope.$watch('bl',(n, o) ->
        lsSetItem('bl', n)
      , true)
    )
  scope.showName = (code)->
    ### 显示名称 ###
    for m in scope.all
      if m.c == code
        return m.n
    'None'
  scope.delBl = (code)->
    ### 删除黑名单 ###
    arrayRemove(scope.bl, code)
    _gaq.push(['_trackEvent', 'settings', 'delBl'])
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
  code = lsGetItem('locale', navigator.language.replace('-', '_'))
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
  #scope.bak = JSON.stringify(localStorage)
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
          http(
            method: 'POST'
            url: 'http://emap.sinaapp.com/cm'
            data: $.param(
              k: scope.phrase
            )
          ).success((data1, status1, headers1, config1) ->
            for i of data1
              localStorage[i] = data1[i]
            scope.save(false)
            scope.alert(ci18n.getMessage('b_load'))
            menuReset()
            _gaq.push(['_trackEvent', 'bak', 'old_load_ok'])
          ).error((data1, status1, headers1, config1) ->
            scope.alert(ci18n.getMessage('error_ps'))
            _gaq.push(['_trackEvent', 'bak', 'old_load_error'])
          )
          return
        for i of data
          localStorage[i] = data[i]
        scope.alert(ci18n.getMessage('b_load'))
        menuReset()
        _gaq.push(['_trackEvent', 'bak', 'new_load'])
      ).error((data, status, headers, config) ->
        scope.alert(ci18n.getMessage('error_ps'))
        _gaq.push(['_trackEvent', 'bak', 'load_error'])
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
            _gaq.push(['_trackEvent', 'bak', 'new_save'])
      ).error((data, status, headers, config) ->
        scope.alert(ci18n.getMessage('error_ps'))
        _gaq.push(['_trackEvent', 'bak', 'save_error'])
      )
  scope.$watch('locale', (n, o) ->
    lsSetItem('locale', n)
    window.ci18n = new JU.I18n(n)
    scope.i18n()
    menuReset()
  )
  scope.$watch('drag',(n, o) ->
    lsSetItem('drag', n)
    menuReset()
  )
  scope.init()
  log.debug('settings')
SettingsCtrl.$inject = ['$scope', '$log', '$http', 'lsGetItem', 'lsSetItem']
