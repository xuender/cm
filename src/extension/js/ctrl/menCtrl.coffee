###
# controllers 控制器
###
sumGroup = (groups)->
  ### 分组排序 ###
  for g in groups
    g.v = 0
    for i in g.items
      g.v += i.v
    JU.sortOn(g.items, '-v')
  JU.sortOn(groups, '-v')
  groups

showSelect = (select, groups = [])->
  ### 显示菜单选择 ###
  for s in select
    for g in groups
      for i in g.items
        if i.c == s.c
          i.select = true
  groups

updateGroup = (items, all)->
  ### 创建自定义分组 ###
  ret = []
  for i in items
    ret.push(
      c: i[0]
      l: 'all'
      g: JU.findArray(all, 'c', i[1])
    )
  ret

updateCustom = (items)->
  ### 创建自定义对象 ###
  ret = []
  for i in items
    ret.push(
      c: i[0]
      l: 'all'
      u: i[1]
      t: 'custom'
    )
  ret

menuReset = ->
  ### 重置菜单 ###
  chrome.runtime.getBackgroundPage (backgroundPage)->
    backgroundPage.menuReset()

menuI18n = (menus, names)->
  ### 翻译菜单 ###
  ret = []
  for m in menus
    if /^\d+$/.test(m.c)
      n = m.n
    else
      n = ci18n.getMessage(m.c)
    if m.c of names
      n = names[m.c]
    ret.push(
      t: ci18n.getMessage(m.t)
      n: n
      b: m.b
      c: m.c
      i: m.i
      h: m.h
      k: m.k
      m: m.m
      l: m.l
      s: m.s
      u: m.u
      v: m.v
    )
  ret

MenCtrl = (scope, routeParams, log, http, $modal, lsGetItem, lsSetItem)->
  ### 菜单控制器 ###
  scope.type = routeParams.type
  name = scope.type.toUpperCase()
  scope.i18n(scope.type)
  $('.i_menucode').text(ci18n.getMessage('i_menucode'))
  for i in ['m_title', 'i_url', 'g_title']
    $('#' + i).attr('placeholder', ci18n.getMessage(i))

  select = routeParams.type + 'Select'
  back = routeParams.type + 'Back'
  incognito = routeParams.type + 'Incognito'
  custom = routeParams.type + 'Custom'
  group = routeParams.type[0] + 'cGroup'
  scope.zh_CN = lsGetItem('zh_CN', false)
  scope.zh_TW = lsGetItem('zh_TW', false)
  scope.ru = lsGetItem('ru', false)
  scope.isEdit = lsGetItem('isEdit', true)
  scope.isFlag = lsGetItem('isFlag', true)
  scope.locale = JU.lsGet('locale', navigator.language.replace('-', '_'))
  if scope.locale not in ['en', 'zh_CN', 'zh_TW']
    scope.locale = 'en'
  # 黑名单
  #scope.bl = lsGetItem('bl', [])
  # 重命名
  scope.names = lsGetItem('names', {})
  # select浮动窗口尺寸
  scope.size = (window.innerHeight - 80)/60
  scope.en = lsGetItem('en', false)
  if lsGetItem('back', false)
    scope.i_back = ci18n.getMessage('i_current')
  else
    scope.i_back = ci18n.getMessage('i_back')
  scope.i_private = ci18n.getMessage('i_private')

  scope.isHideIcon = (menu)->
    ### 判断是否是自定义 ###
    menu.t == 'custom' or 'g' of menu or not scope.isEdit

  scope.init = ->
    ### 初始化 ###
    log.debug('init')
    data = JU.lsGet('all', [])

    scope.allUrls = menuI18n(data, scope.names)
    scope.urls = []
    for d in scope.allUrls
      if d.m == name
        scope.urls.push(d)
    scope.groups = sumGroup(JU.groupBy(scope.urls, 't'))
    scope.custom = updateCustom(lsGetItem(custom, []))
    scope.menus = scope.custom.concat(scope.urls)
  
    scope.$watch('en',(n, o) ->
      lsSetItem('en', n)
    )
    #scope.$watch('bl',(n, o) ->
    #  lsSetItem('bl', n)
    #, true)
    scope.$watch('names',(n, o) ->
      lsSetItem('names', n)
    , true)
    scope.$watch('ru',(n, o) ->
      lsSetItem('ru', n)
    )
    scope.$watch('zh_CN',(n, o) ->
      lsSetItem('zh_CN', n)
    )
    scope.$watch('zh_TW',(n, o) ->
      lsSetItem('zh_TW', n)
    )
    scope.groups.push(
      label: ci18n.getMessage('i_custom')
      items: scope.custom
    )
    scope.group = updateGroup(lsGetItem(group, []), scope.menus)
    scope.select = scope.getSelect()
    scope.groups.push(
      label: ci18n.getMessage('i_group')
      items: scope.group
    )
    showSelect(scope.select, scope.groups)
    scope.$watch('group', (n, o)->
      if scope.f_group_old.$valid
        for m in n
          m.n = m.c
        data = []
        for c in n
          v = []
          for i in c.g
            v.push(i.c)
          data.push([c.c, v])
        lsSetItem(group, data)
    , true)
    # 修改自定义
    scope.$watch('custom', (n, o)->
      if scope.f_custom_old.$valid
        for m in n
          m.n = m.c
        lsSetItem(custom, [c.c, c.u] for c in n)
        scope.menus = n.concat(scope.urls)
    , true)
    # 修改选择项目
    scope.$watch('select', (n, o)->
      s = []
      b = []
      ia = []
      for i in n
        s.push(i.c)
        if i.back
          b.push(i.c)
        if i.incognito
          ia.push(i.c)
      lsSetItem(select, s)
      lsSetItem(back, b)
      lsSetItem(incognito, ia)
      menuReset()
    , true)
    #scope.$apply()

  scope.up = (index)->
    ### 上移 ###
    if index == 0
      return
    t = scope.select[index - 1]
    scope.select[index - 1] = scope.select[index]
    scope.select[index] = t
  scope.down = (index)->
    ### 下移 ###
    if index == scope.select.length - 1
      return
    t = scope.select[index + 1]
    scope.select[index + 1] = scope.select[index]
    scope.select[index] = t

  scope.getSelect = ->
    ### 获取选择菜单 ###
    ret = []
    ss = lsGetItem(select, [])
    bs = lsGetItem(back, [])
    ins = lsGetItem(incognito, [])
    for s in ss
      for a in [scope.menus, scope.group]
        for m in a
          if m.c == s
            m.select = true
            m.back = m.c in bs
            m.incognito = m.c in ins
            ret.push(m)
            break
    ret
  scope.hide =(menu)->
    ### 是否隐藏菜单 ###
    not (menu.l == 'all' or scope[menu.l])
  scope.show = (code)->
    ### 根据代码显示标题 ###
    for a in [scope.menus, scope.custom, scope.group]
      ret = findArray(a, 'c', code)
      if ret
        return ret
    null
  scope.change = (menu)->
    ### 改变菜单选择 ###
    if menu.select
      menu.back = false
      menu.incognito = false
      scope.select.push(menu)
    else
      JU.removeArray(scope.select, menu)
    1
  scope.unSelect = (menu)->
    ### 取消选择 ###
    menu.select = false
    JU.removeArray(scope.select, menu)
  scope.newGroup = g:[], c:'', t: 'group'
  scope.addGroup = (menu)->
    ### 创建自定义组合 ###
    if menu.g and menu.g.length > 0 and scope.f_group.$valid
      menu.n = menu.c
      menu.l = 'all'
      scope.group.push(menu)
      scope.newGroup = angular.copy({})
      $('#g_select_chzn ul.chzn-choices').children('li.search-choice').remove()
      $('#g_title').focus()
      ga('send', 'event', 'group', menu.c)
  scope.delGroup = (menu)->
    ### 删除组合 ###
    if menu.select
      menu.select = false
      scope.change(menu)
    scope.group.splice(scope.group.indexOf(menu), 1)
  scope.newCustom = c: '', u: '', t: 'custom'
  scope.addCustom = (menu)->
    ### 创建自定义菜单 ###
    if scope.f_custom.$valid
      menu.n = menu.c
      menu.l = 'all'
      menu.u = menu.u.replace('%CB%D1%CB%F7%CE%C4%D7%D6','%g')
      menu.u = menu.u.replace('%B7j%AF%C1%A4%E5%A6r','%t')
      menu.u = menu.u.replace('%E6%90%9C%E7%B4%A2%E6%96%87%E5%AD%97','%s')
      menu.u = menu.u.replace('搜索文字','%s')
      menu.u = menu.u.replace('SEARCHTEXT','%s')
      menu.u = menu.u.replace('searchtext','%s')
      scope.custom.push(angular.copy(menu))
      scope.newCustom = angular.copy({t:'custom'})
      $('#m_title').focus()
      ga('send', 'event', 'custom', menu.c)
  scope.delCustom = (menu)->
    ### 删除自定义 ###
    if confirm(ci18n.getMessage('r_del'))
      if menu.select
        menu.select = false
        scope.change(menu)
      scope.custom.splice(scope.custom.indexOf(menu), 1)
  scope.putDialog = (url)->
    ### 弹出上传窗口 ###
    d = $modal.open(
      backdrop: true
      keyboard: true
      backdropClick: true
      templateUrl: 'partials/putUrl.html'
      controller: 'PutCtrl'
      resolve:
        url: ->
          angular.copy(url)
        type: ->
          scope.type
    )
    d.result.then((result)->
      if result
        if result == 'ok'
          alert(scope.getI18n('i_put_ok'))
          ga('send', 'event', 'put', 'share')
        if result == 'have'
          alert(scope.getI18n('i_have'))
          ga('send', 'event', 'put', 'have')
        if result == 'error'
          alert(scope.getI18n('error'))
          ga('send', 'event', 'put', 'error')
    )
  scope.update = (menu)->
    ### 弹出编辑窗口 ###
    d = $modal.open(
      backdrop: true
      keyboard: true
      backdropClick: true
      templateUrl: 'partials/editMenu.html'
      controller: 'EditCtrl'
      resolve:
        menu: ->
          angular.copy(menu)
    )
    d.result.then((result)->
      if result
        if result == 'del'
          scope.remove(menu)
        else if result != 'close'
          if menu.n != result
            menu.n = result
            scope.names[menu.c] = result
            ga('send', 'event', 'edit', 'rename')
    )
  scope.init()
  scope.remove = (menu)->
    ### 删除菜单 ###
    menu.select = false
    JU.removeArray(scope.select, menu)
    for g in scope.groups
      JU.removeArray(g.items, menu)
    all = JU.lsGet('all', [])
    m = JU.findArray(all, 'c', menu.c)
    JU.removeArray(all, m)
    JU.lsSet('all', all)
    for gs in scope.group
      for g in gs.g
        if g.c == menu.c
          JU.removeArray(gs.g, g)
    ga('send', 'event', 'edit', 'del')
MenCtrl.$inject = ['$scope', '$routeParams', '$log', '$http', '$modal',
  'lsGetItem', 'lsSetItem']
