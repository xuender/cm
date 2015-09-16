###
# About controllers 控制器
###
AboutCtrl = (scope, log)->
  ### 关于控制器 ###
  scope.i18n()
  $('#description').text(ci18n.getMessage('description'))
  JU.syncFetch('/manifest.json', (result)->
    scope.ver = JSON.parse(result)['version']
  )
  log.debug('about')
  code = JU.lsGet('locale', navigator.language.replace('-', '_'))
  if code not in ['en', 'zh_CN', 'zh_TW']
    code = 'en'
  scope.isCn = code == 'zh_CN'
AboutCtrl.$inject = ['$scope', '$log']
