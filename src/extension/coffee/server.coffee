###
server.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###

buttonClick = (e)->
  if e.target.tagName == 'I'
    target = e.target.parentElement
  else if e.target.tagName == 'BUTTON'
    target = e.target
  if target
    target.parentElement.parentElement.setAttribute('class', 'success')
    target.remove()
    json = target.getAttribute('json')
    chrome.runtime.sendMessage(
      {
        cmd: 'addMenu'
        json: json
      },
      (response)->
        localStorage['ids'] = JSON.stringify(response.ids)
    )

(->
  bs = document.getElementsByTagName('table')
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
