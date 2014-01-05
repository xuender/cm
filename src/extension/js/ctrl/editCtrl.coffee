EditCtrl = (scope, log, lsGetItem, lsSetItem, $modalInstance, menu)->
  scope.getI18n = (id)->
    ### i18n 字符串 ###
    ci18n.getMessage(id)
  scope.menu = menu
  scope.name = menu.n
  scope.title = menu.h
  scope.nick = menu.k
  scope.close = ->
    $modalInstance.close('close')
  scope.save = ->
    log.debug('save')
    $modalInstance.close(scope.name)
  scope.black = ->
    $modalInstance.close('black')

EditCtrl.$inject = ['$scope', '$log', 'lsGetItem', 'lsSetItem',
  '$modalInstance', 'menu']

