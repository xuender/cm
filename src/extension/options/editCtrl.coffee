ctrls.controller('EditCtrl',[
  '$scope'
  'localStorageService'
  '$modalInstance'
  'dialog'
  'menu'
  (
    $scope
    lls
    $modalInstance
    dialog
    menu
  )->
    $scope.menu = menu
    $scope.name = menu.n
    $scope.title = menu.h
    $scope.nick = menu.k
    $scope.close = ->
      $modalInstance.close('close')
    $scope.save = ->
      $modalInstance.close($scope.name)
      dialog.alert('Save success')
    $scope.del = ->
      dialog.confirm('Are you sure delete this menu?', ->
        $modalInstance.close('del')
      )
])
