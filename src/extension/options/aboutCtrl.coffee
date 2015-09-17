###
# About controllers 控制器
###
ctrls.controller('AboutCtrl',[
  '$scope'
  'localStorageService'
  ($scope, lls)->
    console.log 'about', $scope.locale
    #lls.bind($scope, 'locale', navigator.language.replace('-', '_'))
    #if $scope.locale not in ['en', 'zh_CN', 'zh_TW']
    #  $scope.locale = 'en'
])
