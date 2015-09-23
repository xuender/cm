ctrls.controller('MenusCtrl',[
  '$scope'
  'localStorageService'
  '$modalInstance'
  '$http'
  'dialog'
  'type'
  'groups'
  (
    $scope
    lls
    $modalInstance
    $http
    dialog
    type
    groups
  )->
    $scope.typeValue = [
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
    $scope.type = {}
    for t in $scope.typeValue
      $scope.type[t] = true
    $scope.menus = []
    $scope.all = []
    $http.get('http://localhost:8011/cm/menus')
      .success((data)->
        $scope.all = data
        $scope.load()
      ).error((data)->
        dialog.error('Server Error')
      )
    $scope.load = ->
      $scope.menus = []
      for m in $scope.all
        if m.M == type.toUpperCase()
          if $scope.type[m.T]
            b = true
            for g in groups
              for i in g.items
                if i.c == m.C
                  console.log i.c, m.C
                  b = false
            if b
              $scope.menus.push m
    $scope.$watch('type', (n, o)->
      $scope.load()
    , true)
    $scope.num = 0
    $scope.$watch('menus', (n, o)->
      $scope.num = 0
      for m in n
        if m.s
          $scope.num++
    , true)
    $scope.check = (url)->
      url.indexOf('://') > 0
    $scope.close = ->
      $modalInstance.close('close')
    $scope.down = ->
      ret = []
      for m in $scope.menus
        if m.s
          ret.push m
      $modalInstance.close(ret)
])
