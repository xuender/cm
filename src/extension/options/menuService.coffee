###
menuService.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###

services.factory('menu', [
  ->
    console.log 'menu service'
    # 菜单重置
    reset = ->
      console.log 'menu reset'
      chrome.runtime.getBackgroundPage (backgroundPage)->
        backgroundPage.menuReset()
    {
      reset: reset
    }
])

