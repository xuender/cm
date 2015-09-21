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
  if not items
    items = []
  ret = []
  for i in items
    ret.push(
      c: i[0]
      l: 'all'
      g: JU.findArray(all, 'c', i[1])
    )
  ret



ctrls.controller('MenuCtrl',[
  '$scope'
  '$stateParams'
  'localStorageService'
  '$menu'
  'i18n'
  '$modal'
  (
    $scope
    $stateParams
    lls
    $menu
    i18n
    $modal
  )->
    ### 菜单控制器 ###
    $scope.type = $stateParams.type
    name = $scope.type.toUpperCase()
    #scope.i18n(scope.type)

    select = $stateParams.type + 'Select'
    back = $stateParams.type + 'Back'
    incognito = $stateParams.type + 'Incognito'
    custom = $stateParams.type + 'Custom'
    group = $stateParams.type[0] + 'cGroup'
    lls.bind($scope, 'zh_CN', false)
    lls.bind($scope, 'zh_TW', false)
    lls.bind($scope, 'ru', false)
    lls.bind($scope, 'en', false)
    lls.bind($scope, 'isEdit', true)
    lls.bind($scope, 'isFlag', true)
    # 黑名单
    #scope.bl = lsGetItem('bl', [])
    # 重命名
    lls.bind($scope, 'names', {})
    # select浮动窗口尺寸
    $scope.size = (window.innerHeight - 80)/60
    lls.bind($scope, 'back', false)
    
    $scope.isHideIcon = (menu)->
      ### 判断是否是自定义 ###
      menu.t == i18n.get('Custom') or 'g' of menu or not $scope.isEdit

    # 翻译菜单
    $scope.menuI18n = (menus, names)->
      console.log 'i18n local', i18n.locale()
      ret = []
      for m in menus
        n = i18n.get(m.c, m.n)
        #n = m.c#, m.n)
        if m.c of names
          n = names[m.c]
        ret.push(
          t: i18n.get(m.t)
          #t: m.t
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
    $scope.updateCustom = (items)->
      ### 创建自定义对象 ###
      if not items
        items = []
      ret = []
      for i in items
        ret.push(
          c: i[0]
          l: 'all'
          u: i[1]
          t: i18n.get 'Custom'
        )
      ret
    $scope.init = ->
      ### 初始化 ###
      console.log('menu init')
      data = JU.lsGet('all', [])

      $scope.allUrls = $scope.menuI18n(data, $scope.names)
      $scope.urls = []
      for d in $scope.allUrls
        if d.m == name
          $scope.urls.push(d)
      $scope.groups = sumGroup(JU.groupBy($scope.urls, 't'))
      $scope.custom = $scope.updateCustom(lls.get(custom))
      $scope.menus = $scope.custom.concat($scope.urls)
    
      $scope.groups.push(
        label: i18n.get('i_custom')
        items: $scope.custom
      )
      $scope.group = updateGroup(lls.get(group), $scope.menus)
      $scope.select = $scope.getSelect()
      $scope.groups.push(
        label: i18n.get('i_group')
        items: $scope.group
      )
      showSelect($scope.select, $scope.groups)
      $scope.$watch('group', (n, o)->
        if $scope.f_group_old.$valid
          for m in n
            m.n = m.c
          data = []
          for c in n
            v = []
            for i in c.g
              v.push(i.c)
            data.push([c.c, v])
          lls.set(group, data)
      , true)
      # 修改自定义
      $scope.$watch('custom', (n, o)->
        if $scope.f_custom_old.$valid
          for m in n
            m.n = m.c
          lls.set(custom, [c.c, c.u] for c in n)
          $scope.menus = n.concat($scope.urls)
      , true)
      # 修改选择项目
      $scope.$watch('select', (n, o)->
        s = []
        b = []
        ia = []
        for i in n
          s.push(i.c)
          if i.back
            b.push(i.c)
          if i.incognito
            ia.push(i.c)
        lls.set(select, s)
        lls.set(back, b)
        lls.set(incognito, ia)
        $menu.reset()
      , true)
      #scope.$apply()

    $scope.up = (index)->
      ### 上移 ###
      if index == 0
        return
      t = $scope.select[index - 1]
      $scope.select[index - 1] = $scope.select[index]
      $scope.select[index] = t
    $scope.down = (index)->
      ### 下移 ###
      if index == $scope.select.length - 1
        return
      t = $scope.select[index + 1]
      $scope.select[index + 1] = $scope.select[index]
      $scope.select[index] = t

    $scope.getSelect = ->
      ### 获取选择菜单 ###
      ret = []
      ss = lls.get(select)
      if not ss then ss = []
      bs = lls.get(back)
      if not bs then bs = []
      ins = lls.get(incognito)
      if not ins then ins = []
      for s in ss
        for a in [$scope.menus, $scope.group]
          for m in a
            if m.c == s
              m.select = true
              m.back = m.c in bs
              m.incognito = m.c in ins
              ret.push(m)
              break
      ret
    $scope.hide =(menu)->
      ### 是否隐藏菜单 ###
      not (menu.l == 'all' or $scope[menu.l])
    $scope.show = (code)->
      ### 根据代码显示标题 ###
      for a in [$scope.menus, $scope.custom, $scope.group]
        ret = findArray(a, 'c', code)
        if ret
          return ret
      null
    $scope.change = (menu)->
      ### 改变菜单选择 ###
      if menu.select
        menu.back = false
        menu.incognito = false
        $scope.select.push(menu)
      else
        JU.removeArray($scope.select, menu)
      1
    $scope.unSelect = (menu)->
      ### 取消选择 ###
      menu.select = false
      JU.removeArray($scope.select, menu)
    $scope.newGroup = g:[], c:'', t: 'group'
    $scope.addGroup = (menu)->
      ### 创建自定义组合 ###
      if menu.g and menu.g.length > 0 and $scope.f_group.$valid
        menu.n = menu.c
        menu.l = 'all'
        $scope.group.push(menu)
        $scope.newGroup = angular.copy({})
        $('#g_select_chzn ul.chzn-choices').children('li.search-choice').remove()
        $('#g_title').focus()
        ga('send', 'event', 'group', menu.c)
    $scope.delGroup = (menu)->
      ### 删除组合 ###
      if confirm(i18n.get('r_del'))
        if menu.select
          menu.select = false
          $scope.change(menu)
        $scope.group.splice($scope.group.indexOf(menu), 1)
    $scope.newCustom = c: '', u: '', t: 'custom'
    $scope.addCustom = (menu)->
      ### 创建自定义菜单 ###
      if $scope.f_custom.$valid
        menu.n = menu.c
        menu.l = 'all'
        menu.u = menu.u.replace('%CB%D1%CB%F7%CE%C4%D7%D6','%g')
        menu.u = menu.u.replace('%B7j%AF%C1%A4%E5%A6r','%t')
        menu.u = menu.u.replace('%E6%90%9C%E7%B4%A2%E6%96%87%E5%AD%97','%s')
        menu.u = menu.u.replace('搜索文字','%s')
        menu.u = menu.u.replace('SEARCHTEXT','%s')
        menu.u = menu.u.replace('searchtext','%s')
        $scope.custom.push(angular.copy(menu))
        $scope.newCustom = angular.copy({t:i18n.get('custom')})
        $('#m_title').focus()
        ga('send', 'event', 'custom', menu.c)
    $scope.delCustom = (menu)->
      ### 删除自定义 ###
      if confirm(i18n.get('r_del'))
        if menu.select
          menu.select = false
          $scope.change(menu)
        $scope.custom.splice($scope.custom.indexOf(menu), 1)
    # 弹出上传窗口
    $scope.putDialog = (url)->
      d = $modal.open(
        backdrop: true
        keyboard: true
        backdropClick: true
        templateUrl: 'options/putUrl.html'
        controller: 'PutCtrl'
        resolve:
          url: ->
            angular.copy(url)
          type: ->
            $scope.type
      )
      d.result.then((result)->
        if result
          if result == 'ok'
            alert(i18n.get('i_put_ok'))
            ga('send', 'event', 'put', 'share')
          if result == 'have'
            alert(i18n.get('i_have'))
            ga('send', 'event', 'put', 'have')
          if result == 'error'
            alert(i18n.get('error'))
            ga('send', 'event', 'put', 'error')
      )
    # 弹出编辑窗口
    $scope.update = (menu)->
      d = $modal.open(
        backdrop: true
        keyboard: true
        backdropClick: true
        templateUrl: 'options/editMenu.html'
        controller: 'EditCtrl'
        resolve:
          menu: ->
            angular.copy(menu)
      )
      d.result.then((result)->
        if result
          if result == 'del'
            $scope.remove(menu)
          else if result != 'close'
            if menu.n != result
              menu.n = result
              $scope.names[menu.c] = result
      )
    $scope.init()
    # 删除菜单
    $scope.remove = (menu)->
      menu.select = false
      JU.removeArray($scope.select, menu)
      for g in $scope.groups
        JU.removeArray(g.items, menu)
      all = JU.lsGet('all', [])
      m = JU.findArray(all, 'c', menu.c)
      JU.removeArray(all, m)
      JU.lsSet('all', all)
      for gs in $scope.group
        for g in gs.g
          if g.c == menu.c
            JU.removeArray(gs.g, g)
])
