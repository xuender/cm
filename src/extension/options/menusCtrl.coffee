ctrls.controller('MenusCtrl',[
  '$scope'
  'localStorageService'
  '$modalInstance'
  '$http'
  'dialog'
  'type'
  'groups'
  'i18n'
  'NgTableParams'
  '$q'
  (
    $scope
    lls
    $modalInstance
    $http
    dialog
    type
    groups
    i18n
    NgTableParams
    $q
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
      'Custom'
    ]
    $scope.lname = i18n.get('Name')
    $scope.ltype = i18n.get('Type')
    $scope.lurl= i18n.get('URL')
    $scope.lcount = i18n.get('Points')
    console.log $scope.lname
    $scope.menus = []
    $http.get('http://oldbean.cn/cm/menus')
      .success((data)->
        for m in data
          if m.M == type.toUpperCase()
            $scope.menus.push m
        $scope.tableParams = new NgTableParams(
          page: 1
          count: 10
          sorting:
            V: 'desc'
        ,
          filterDelay: 0
          data: $scope.menus
        )
      ).error((data)->
        dialog.error('Server Error')
      )
    $scope.selectLanguage = ->
      def = $q.defer()
      arr = []
      for k in LANGUAGE
        arr.push(
          id: k
          title: i18n.get(k)
        )
      def.resolve(arr)
      def

    $scope.selectType = ->
      def = $q.defer()
      arr = []
      for k in $scope.typeValue
        arr.push(
          id: k
          title: i18n.get(k)
        )
      def.resolve(arr)
      def
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
