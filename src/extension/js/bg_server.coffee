###
bg_server.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
  if request.cmd == 'getIds'
    getIds(sendResponse)

getIds = (sendResponse)->
  ### 获取所有在用的ID ###
  all = JU.lsGet('all', [])
  ids = ['qr_lin']
  for i in all
    ids.push i.c
  sendResponse(
    ids: ids
  )
