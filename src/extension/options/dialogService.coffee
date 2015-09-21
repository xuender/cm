###
dialogService.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###

services.factory('dialog', [
  '$modal'
  '$rootScope'
  'i18n'
  ($modal, $rootScope, i18n)->
    console.log 'dialog service'
    dialog = (msg, type='alert', close='Close', other='', cb)->
      console.log 'dialog', msg
      alertScope = $rootScope.$new(true)
      alertScope.msg = msg
      alertScope.type = type
      alertScope.closeTxt = close
      alertScope.other = other
      alertScope.close = ->
        alertScope.modalInstance.close(alertScope)
      # 回调
      alertScope.cb = ->
        if cb()
          alertScope.close()
      alertScope.modalInstance = $modal.open(
        backdrop: true
        keyboard: true
        backdropClick: true
        templateUrl: 'options/dialog.html'
        scope: alertScope
        size: 'sm'
      )
    {
      alert: (msg)->
        dialog(msg, 'Alert')
      error: (msg)->
        dialog(msg, 'Error')
      confirm: (msg, cb, close='No', other='Yes')->
        dialog(msg, 'Confirm', close, other, cb)
    }
])

