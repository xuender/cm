###
# Settings controllers 控制器
###
ctrls.controller('SettingsCtrl',[
  '$scope'
  '$http'
  'localStorageService'
  '$menu'
  'dialog'
  (
    $scope
    $http
    lls
    $menu
    dialog
  )->
    ### 设置控制器 ###
    lls.bind($scope, 'lt1', '1')
    lls.bind($scope, 'lt1', '1')
    lls.bind($scope, 'lt2', '1')
    lls.bind($scope, 'rt1', '1')
    lls.bind($scope, 'rt2', '2')
    lls.bind($scope, 'lb1', '2')
    lls.bind($scope, 'lb2', '1')
    lls.bind($scope, 'rb1', '2')
    lls.bind($scope, 'rb2', '2')

    lls.bind($scope, 'qr_size', 250)
    lls.bind($scope, 'isEdit', true)
    lls.bind($scope, 'isFlag', true)
    lls.bind($scope, 'analytics', true)

    lls.bind($scope, 'back', false)
    lls.bind($scope, 'newPage', true)
    lls.bind($scope, 'phrase', '')

    $scope.alerts= []
    $scope.all = []
    #scope.all = menuI18n(JU.lsGet('all',[]), [])
    $scope.showName = (code)->
      ### 显示名称 ###
      for m in $scope.all
        if m.c == code
          return m.n
      'None'
    lls.bind($scope, 'shorten', 'googl')
    # 读取设置信息
    $scope.read = ->
      $scope.bakstr = JSON.stringify(localStorage)
      #dialog.alert('Read Settings')
    # 加载2
    $scope.load2 = ->
      dialog.confirm('Are you sure Load Settings?', ->
        data = JSON.parse($scope.bakstr)
        if typeof(data) == 'object'
          for i of localStorage
            if i of data
              localStorage[i] = data[i]
          $menu.reset()
        else
          dialog.error('Settings string error')
        return true
      )
    $scope.load = ->
      if $scope.bak.$valid
        dialog.confirm('Are you sure Load Settings?', ->
          $http.get("http://oldbean.cn/cm/settings?phrase=#{hex_sha1($scope.phrase)}")
            .success((data, status, headers, config) ->
              if data == 'error' or data == ''
                dialog.error('Server Error')
                return
              if typeof(data) == 'object'
                #$scope.bakstr = JSON.stringify(data) # test
                for i of data
                  localStorage[i] = data[i]
                dialog.alert('Load Settings')
                $menu.reset()
                $scope.initLocal()
              else
                dialog.error('The wrong pass phrase')
            ).error((data, status, headers, config) ->
              dialog.error('The wrong pass phrase')
            )
        )
    # 保存
    $scope.save = (msg=true)->
      #p = ''
      #ps = []
      #for l, i in $scope.bakstr.split('\n')
      #  if i % 2
      #    ps.push(
      #      p: p
      #      j: JSON.parse(l)
      #    )
      #    json = l
      #  else
      #    p = l
      #  for i in ps
      #    $http.post("http://oldbean.cn/cm/settings?phrase=#{i.p}", i.j)
      if $scope.bak.$valid
        lls.set('phrase', $scope.phrase)
        $http.post("http://oldbean.cn/cm/settings?phrase=#{hex_sha1($scope.phrase)}",localStorage)
          .success((data, status, headers, config) ->
            if 'ok' == data
              if msg
                dialog.alert('Save Settings')
          ).error((data, status, headers, config) ->
            dialog.alert('The wrong pass phrase')
          )
    console.log('settings')

])
