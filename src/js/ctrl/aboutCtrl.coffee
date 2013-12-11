###
# About controllers 控制器
###
AboutCtrl = (scope, log)->
  ### 关于控制器 ###
  scope.i18n()
  $('#description').text(ci18n.getMessage('description'))
  syncFetch('/manifest.json', (result)->
    scope.ver = JSON.parse(result)['version']
  )
  log.debug('about')
AboutCtrl.$inject = ['$scope', '$log']
