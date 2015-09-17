###
menuService.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###

services.factory('menu', [
  '$log'
  ($log)->
    $log.debug 'menu service'
    reset = ->
      $log.debug 'menu reset'
    {
      reset: reset
    }
])

