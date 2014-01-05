PutCtrl = (scope, log, http, lsGetItem, lsSetItem, $modalInstance, url, type)->
  scope.getI18n = (id)->
    ### i18n 字符串 ###
    ci18n.getMessage(id)
  scope.type = type.toUpperCase()
  scope.name = url.c
  scope.url = url.u
  scope.nick = lsGetItem('nick', '')
  scope.title = ''
  scope.locale = lsGetItem('locale', 'en')
  scope.close = ->
    log.debug('close')
    $modalInstance.close('close')
  scope.put = ->
    lsSetItem('nick', scope.nick)
    #  url: 'http://cm.xuender.me/url/put/'
    http(
      method: 'POST'
      url: 'http://cm.xuender.me/url/put/'
      data: $.param(
        name: scope.name
        url: scope.url
        nick: scope.nick
        title: scope.title
        hl: scope.locale
        mode: scope.type
      )
    ).success((data, status, headers, config) ->
      #scope.alert(ci18n.getMessage('b_load'))
      $modalInstance.close(data)
      _gaq.push(['_trackEvent', 'db', 'put'])
    ).error((data, status, headers, config) ->
      $modalInstance.close(data)
      _gaq.push(['_trackEvent', 'db', 'put_error'])
    )
PutCtrl.$inject = ['$scope', '$log', '$http', 'lsGetItem', 'lsSetItem',
  '$modalInstance', 'url', 'type']
