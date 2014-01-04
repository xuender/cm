###
server.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
chrome.runtime.sendMessage(
  {cmd: 'getIds'},
  (response)->
    #document.getElementById('ids').value = JSON.stringify(response)
    localStorage['ids'] = JSON.stringify(response.ids)
    #$('body').scope().userIds(response)
    #$('body').scope().$apply()
)
