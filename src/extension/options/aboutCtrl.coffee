###
# About controllers 控制器
###
ctrls.controller('AboutCtrl',[
  '$scope'
  ($scope)->
    console.log 'about', $scope.locale
])
