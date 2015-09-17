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
  if request.cmd == 'setAll'
    setAll(request.all)

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

setAll = (all)->
  ### 刷新全部菜单 ###
  oldAll = JU.lsGet('all', [])
  newAll = []
  for n in JSON.parse(all)
    b = false
    for o in oldAll
      if n.c == o.c then b = true
    if b then newAll.push(n)
  JU.lsSet('all', newAll)
