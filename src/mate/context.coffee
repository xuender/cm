###
context.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
s_x = 0
s_y = 0
if 's_b' not of window
  window.s_b = true
  document.addEventListener('dragstart', (e)->
    s_x = e.screenX
    s_y = e.screenY
  , false)
  document.addEventListener('dragover', (e)->
    if e.toElement.tagName == 'INPUT' or e.toElement.tagName == 'TEXTAREA'
      return true
    if e.preventDefault
      e.preventDefault()
    false
  , false)
  document.addEventListener('drop', (e)->
    if e.toElement.tagName == 'INPUT' or e.toElement.tagName == 'TEXTAREA'
      return true
    if e.preventDefault
      e.preventDefault()
    x = 1
    if e.screenX < s_x
      x = -1
    y = 1
    if e.screenY < s_y
      y = -1
    data = e.dataTransfer.getData('URL')
    msg = 'url'
    if !data
      data = e.dataTransfer.getData('Text')
      msg = 'txt'
    if data
      chrome.runtime.sendMessage('mhklklghjhnlacpcddonhkfockldmamd',
        cmd: msg
        values: data
        x: x
        y: y
      )
      false
  , true)
