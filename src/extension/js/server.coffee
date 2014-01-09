###
server.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###

buttonClick = (e)->
  e.target.parentElement.parentElement.setAttribute('class', 'success')
  e.target.remove()
  json = e.target.getAttribute('json')
  chrome.runtime.sendMessage(
    {
      cmd: 'addMenu'
      json: json
    },
    (response)->
      localStorage['ids'] = JSON.stringify(response.ids)
      alert('增加成功')
  )

(->
  os = document.getElementsByClassName('o')
  for o in os
    o.setAttribute('class','o')
  bs = document.getElementsByClassName('b')
  for b in bs
    b.addEventListener('click', buttonClick)
  chrome.runtime.sendMessage(
    {cmd: 'getIds'},
    (response)->
      localStorage['ids'] = JSON.stringify(response.ids)
      all = document.getElementById('all').value
      chrome.runtime.sendMessage(
        cmd: 'setAll'
        all: all
      )
  )
)()
