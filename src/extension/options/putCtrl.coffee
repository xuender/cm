ctrls.controller('PutCtrl',[
  '$scope'
  '$http'
  'localStorageService'
  '$modalInstance'
  'dialog'
  'url'
  'type'
  (
    $scope
    $http
    lls
    $modalInstance
    dialog
    url
    type
  )->
    $scope.type = type.toUpperCase()
    $scope.name = url.c
    $scope.url = url.u
    lls.bind($scope, 'nick', '')
    $scope.title = ''
    $scope.locale = lls.get('locale')
    $scope.close = ->
      console.log('close')
      $modalInstance.close('close')
    $scope.put = ->
      #  url: 'http://cm.xuender.me/url/put/'
      $http(
        method: 'POST'
        url: 'http://cm.xuender.me/url/put/'
        data: $.param(
          name: $scope.name
          url: $scope.url
          nick: $scope.nick
          title: $scope.title
          hl: $scope.locale
          mode: $scope.type
        )
      ).success((data, status, headers, config) ->
        $modalInstance.close(data)
        dialog.alert('Shared success')
      ).error((data, status, headers, config) ->
        dialog.error('Server Error')
      )
])
