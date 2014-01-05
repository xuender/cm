###
bg_server.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
  if request.cmd == 'getIds'
    getIds(sendResponse)
  if request.cmd == 'addMenu'
    addMenu(request.json, sendResponse)

getIds = (sendResponse)->
  ### 获取所有在用的ID ###
  all = JU.lsGet('all', [])
  ids = []
  for i in all
    ids.push i.c
  sendResponse(
    ids: ids
  )

addMenu = (json, sendResponse)->
  ### 增加菜单 ###
  all = JU.lsGet('all', [])
  all.push(JSON.parse(json))
  JU.lsSet('all', all)
  getIds(sendResponse)
