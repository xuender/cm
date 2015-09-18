###
menuService.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###

services.factory('menu', [
  '$log'
  ($log)->
    $log.debug 'menu service'
    # 菜单重置
    reset = ->
      $log.debug 'menu reset'
      chrome.runtime.getBackgroundPage (backgroundPage)->
        backgroundPage.menuReset()
    {
      reset: reset
    }
])

