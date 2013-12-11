###
#utilServices 工具服务模块
* ls 获取 localStorage
* lsGetItem 读取变量
* lsSetItem 写入变量
###
angular.module('utils.services', []).config(['$provide', ($provide)->
  # 获取ls对象
  $provide.factory('ls',[->
    ->
      localStorage
  ])
  # 读数据
  $provide.factory('lsGetItem', [->
    (key, defaultValue = false)->
      JU.lsGet key, defaultValue
  ])
  # 写数据
  $provide.factory('lsSetItem', [->
    (key, value)->
      JU.lsSet key, value
  ])
])
