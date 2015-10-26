lsGet = (key, def=key)->
  if key of localStorage
    return JSON.parse(localStorage[key])
  def
ctrls.controller('PopupCtrl',[
  '$scope'
  '$translate'
  (
    $scope
    $translate
  )->
    ga('send', 'event', 'popup', 'open')
    # local
    locale = lsGet('locale', '')
    if not locale
      locale = navigator.language.replace('-', '_')
    if locale not in LANGUAGE
      locale = 'en'
    $translate.use(locale)

    $scope.text = ''
    $scope.btns = []
    $scope.defaultSearch = ->
      if $scope.btns.length > 0
        $scope.search($scope.btns[0].id)
    $scope.read = (type, text)->
      $scope.text = text
      $scope.type = type
      bs = lsGet("#{type}Back", [])
      ins = lsGet("#{type}Incognito", [])
      select = lsGet($scope.type + 'Select', [])
      custom = lsGet(type + 'Custom', [])
      group = lsGet(type[0] + 'cGroup', [])
      urls = lsGet('all', [])
      names = lsGet('names', {})
      for id in select
        b = true
        for u in urls
          if u.c == id
            b = false
            name = id
            if not name
              name = u.n
            if u.c of names
              name = names[u.c]
        if b
          name = id
        if not name
          name = id
        incognito = id in ins
        if incognito
          name = '☢ ' + name
        else
          back = id in bs
          if back
            name = '₪ ' + name
        $scope.btns.push(id: id, name:name)
      $scope.$apply()
    chrome.tabs.query(
      active: true
      windowId: chrome.windows.WINDOW_ID_CURRENT
    , (tabs)->
      id = tabs[0].id
      if /http.+|ftp.+/.test(tabs[0].url)
        chrome.tabs.executeScript(id,
          code: '[document.head.getAttribute("data-c-m-t"),' +
          'document.head.getAttribute("data-c-m-v")]'
        ,(r)->
          if not r or not r[0] or not r[0][0]
            chrome.tabs.executeScript(id,
              code: 'var _v;var _t=document.body.getElementsByTagName("input");'+
              'for(var i in _t){if(_t[i].type=="text"){_v=_t[i].value;break;}}_v;'
            ,(r2)->
              value = ''
              if r2 and r2[0]
                value = r2[0]
              $scope.read 'txt', value
            )
          else
            $scope.read r[0][0], r[0][1]
        )
      else
        $scope.read 'txt', ''
    )
    $scope.search = (id)->
      chrome.tabs.getSelected(null, (tab)->
        chrome.runtime.getBackgroundPage (backgroundPage)->
          backgroundPage.openTab(id, $scope.type, $scope.text, false, tab)
      )
      ga('send', 'event', 'popup', id)
    1
])
