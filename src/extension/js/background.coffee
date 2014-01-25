###
# background 后台运行
创建右键菜单，监听菜单刷新事件
###
run = true
chrome.contextMenus.onClicked.addListener((info, tab)->
  ### 单击事件 ###
  type = info.menuItemId[0]
  id = info.menuItemId[1..]
  type = getType(type)
  value = getValue(info, tab, type)
  openTab(id, type, value, tab)
)
chrome.runtime.onStartup.addListener(->
  if run
    menuReset()
)
chrome.runtime.onInstalled.addListener(->
  all = JU.lsGet('all', [])
  if all.length == 0
    JU.syncFetch('/init.json', (result)->
      JU.lsSet('all', JSON.parse(result))
      ga('send', 'event', 'db', 'ninit')
    )
  ci18n = getCi18n()
  if not JU.lsGet('three_run', false)
    i18n = ci18n.getMessage('i18n')
    JU.lsSet('en', true)
    if i18n == 'cn'
      JU.lsSet('zh_CN', true)
      data =
        txtSelect: ['baidu', 'translate', 'amazon']
        picSelect: ['google_pic', 'baidu_pic', 'su_pic', 'qr_decode']
        linSelect: ['weibo_lin', 'gmail_lin', 'qr_lin']
        menSelect: ['i_title']
    else if i18n == 'tw'
      JU.lsSet('zh_TW', true)
    else if i18n == 'ru'
      JU.lsSet('ru', true)
    if not data
      data =
        txtSelect: ['bing', 'translate', 'Amazon_com']
        picSelect: ['google_pic', 'su_pic', 'qr_decode']
        linSelect: ['gmail_lin', 'qr_lin']
        menSelect: ['i_title']
    for key of data
      JU.lsSet(key, JU.lsGet(key, data[key]))
    chrome.tabs.create({url:'options.html', selected: true})
    JU.lsSet('three_run', true)
    ga('send', 'event', 'option', 'init')
  menuReset()
)

#getUrls = (custom, ids, fun)->
#  ### 根据ids查找URL,返回URL列表 ###
#  for id in ids
#    _gaq.push(['_trackEvent', 'menu', id])
#    findUrl(id, (ur)->
#      fun(ur)
#    )
#    for c in custom
#      if c[0] == id
#        fun(c[1])
getValue = (info, tab, type)->
  ### 根据类型决定参数值 ###
  {
    'men': tab.url
    'txt': info.selectionText
    'pic': info.srcUrl
    'lin': info.linkUrl
  }[type]

show = (url, value, tab, back=false, incognito=false, x=1, type='txt')->
  ### 根据网址、变量打开页面 网址,变量,后台,类型,隐身,tab,左右###
  if /%l|%L/g.test(url)
    url = url.replace(/%l|%L/g, encodeURIComponent(tab.title))
  if /%s|%S/g.test(url)
    url = url.replace(/%s|%S/g, encodeURIComponent(value))
    #u = /%u|%U/g
    #if u.test(url)
    #  u.lastIndex=0
    #  url = url.replace(u, encoden(value))
  if /%g|%G/g.test(url)
    url = url.replace(/%g|%G/g, encodeToGbk(value))
  if /%t|%T/g.test(url)
    url = url.replace(/%t|%T/g, encodeToBig5(value))
  if /%p|%P/g.test(url)
    url = url.replace(/%p|%P/g, encodeURIComponent(readClipboard()))
  if /%u|%U/g.test(url) and tab
    doman = tab.url.split('/')[2]
    url = url.replace(/%u|%U/g, doman)
  openUrl(url, tab, back, incognito, x, type, value)

openUrl = (url, tab, back=false, incognito=false, x=1, type='txt', value='')->
  ### 打开URL ###
  if tab
    ni = tab.index
  if x > 0
    ni++
  if incognito
    # 隐身窗口
    chrome.windows.create(
      url: url
      incognito: true
    )
    return true
  if JU.lsGet('newPage', true)
    chrome.tabs.getAllInWindow(null,(tabs)->
      for t in tabs
        if isCurrent(t.url, url)
          chrome.tabs.update(t.id, {selected: !back})
          showPageAction(t, type, value)
          return
      chrome.tabs.create({url:url, selected: !back, index : ni}, (tab)->
        showPageAction(tab, type, value)
      )
      true
    )
  else
    chrome.tabs.create({url:url, selected: !back, index : ni}, (tab)->
      showPageAction(tab, type, value)
    )
  true

showPageAction = (tab, type, value)->
  ### 根据ID显示弹出选项 ###
  if /http.+|ftp.+/.test(tab.url)
    chrome.tabs.executeScript(tab.id,
      code: "document.head.setAttribute('data-c-m-t','#{type}');"+
      "document.head.setAttribute('data-c-m-v','#{value.replace("'","\\'")}');"
    )

isCurrent = (turl, url)->
  ### 判断是否是当前页面 ###
  if 'options.html' == url
    if turl.indexOf('phlfmkfpmphogkomddckmggcfpmfchpn') > 0
      if turl.indexOf('chrome-extension') == 0 and turl.indexOf(url) > 0
        return true
  url == turl

getType = (t)->
  ### 获取类型 ###
  for type in ['men', 'txt', 'pic', 'lin']
    if t == type[0]
      return type
  'menu'

execute = (id, value, tab, back, incognito)->
  ### 执行特殊命令 id, value, tab, back, incognito, x ###
  noInc = {
    kd: queryKd
    qr: createQR
    qr_pic: createQR
    qr_txt: createQR
    qr_lin: createQR
    qr_decode: qrcode.decode
    tab_close: tabClose
  }
  if id of noInc
    noInc[id](value, tab, back, incognito)
  inc = {
    su: shortenUrlCopy
    su_lin: shortenUrlCopy
    su_pic: shortenUrlCopy
    su_alert: shortenUrlAlert
    su_lin_alert: shortenUrlAlert
    su_pic_alert: shortenUrlAlert
  }
  if id of inc
    inc[id](value, tab, back, incognito)

getCustomUrl = (array, id)->
  for c in array
    if c[0] == id
      return [c[1]]
  []

getAllUrl = (array, id)->
  u = JU.findArray(array, 'c', id)
  if u
    return [u.u]
  []

openTab = (id, type, value, tab, x=1, fg=null)->
  ### 打开tab页面 id,类型,变量,tab,左右###
  back = id in JU.lsGet("#{type}Back", [])
  incognito = id in JU.lsGet("#{type}Incognito", [])
  back = if JU.lsGet("back", false) then !back else back
  back = if fg != null then fg else back

  all = JU.lsGet('all', [])
  urls = getAllUrl(all, id)
  custom = JU.lsGet(type + 'Custom', [])
  urls = urls.concat(getCustomUrl(custom, id))
  group = JU.lsGet(type[0] + 'cGroup', [])
  for g in group
    if g[0] == id
      for gid in g[1]
        urls = urls.concat(getCustomUrl(custom, gid))
        urls = urls.concat(getAllUrl(all, gid))
  for u in urls
    ga('send', 'event', 'menu', id)
    if /:|.htm/.test(u)
      show(u, value, tab, back, incognito, x, type)
    else
      # 特殊功能，例如QR码等
      execute(u, value, tab, back, incognito, x)
  true

getCi18n = ->
  if 'ci18n' not in window
    code = JU.lsGet('locale', navigator.language.replace('-', '_'))
    if code not in ['en', 'zh_CN', 'zh_TW']
      code = 'en'
    window.ci18n = new JU.I18n(code)
  window.ci18n

menuReset = ->
  ### 重置菜单 ###
  run = false
  ci18n = getCi18n()
  chrome.contextMenus.removeAll(->
    for type in ['men', 'txt', 'pic', 'lin']
        ### 创建菜单 ###
        select = JU.lsGet(type + 'Select', [])
        if type == 'lin'
          chrome.contextMenus.create(
            "contexts": ['link']
            'type': 'separator'
            'id': 's_' + JU.getId()
          )
        all = JU.lsGet('all', [])
        names = JU.lsGet('names', {})
        for id in select
          u = JU.findArray(all, 'c', id)
          if u
            name = ci18n.getMessage(id)
            if not name
              name = u.n
            if u.c of names
              name = names[u.c]
            createMenuItem(id, name, type)
          else
            createMenuItem(id, id, type)
    console.debug 'menu reset'
  )
#  if JU.lsGet('drag', false)
#    if not chrome.tabs.onUpdated.hasListener(updated)
#      chrome.tabs.onUpdated.addListener(updated)
#  else
#    if chrome.tabs.onUpdated.hasListener(updated)
#      chrome.tabs.onUpdated.removeListener(updated)
#
#updated = (tabId, changeInfo, tab)->
#  ### 创建 ###
#  if /http.+|ftp.+/.test(tab.url)
#    chrome.tabs.executeScript(tab.id, {file: "js/context.js"})
#created = (tab)->
#  ### 创建 ###
#  if /http.+|ftp.+/.test(tab.url)
#    chrome.tabs.executeScript(tab.id, {file: "js/context.js"})
getContexts = (type)->
  ### 菜单类型 ###
  {
    'men': 'page'
    'txt': 'selection'
    'pic': 'image'
    'lin': 'link'
  }[type]
createMenuItem = (id, name, type)->
  cid = type[0] + id
  ins = JU.lsGet("#{type}Incognito", [])
  bs = JU.lsGet("#{type}Back", [])
  incognito = id in ins
  if incognito
    name = '☢ ' + name
  else
    back = id in bs
    if back
      name = '₪ ' + name
  try
    chrome.contextMenus.create(
      "title": name
      "contexts": [getContexts(type)]
      'id': cid
    )
  catch err
    console.error err
#menuReset()
chrome.extension.onConnect.addListener((port)->
  port.onMessage.addListener((data)->
    if JU.lsGet('drag', true) and (data.message == 'url' or data.message == 'txt')
      chrome.tabs.getSelected(null, (tab)->
        fg = (data.y == 1)
        if data.message == 'url'
          show(data.values, '', tab, fg, false, data.x)
          ga('send', 'event', 'drag', 'url')
        if data.message == 'txt'
          id = JU.lsGet('txtSelect', ['baidu'])[0]
          url = data.values.trim()
          if JU.isUrl(url)
            if not JU.isProtocol(url)
              url = "http://#{url}"
            openUrl(url, tab, fg, false, data.x)
            ga('send', 'event', 'drag', 'url')
          else
            openTab(id, 'txt', data.values, tab, data.x, fg)
            ga('send', 'event', 'drag', id)
      )
  )
)
if run
  console.info 'run'
  menuReset()
