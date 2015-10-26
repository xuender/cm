###
chromereload.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###


LIVERELOAD_HOST = 'localhost:'
LIVERELOAD_PORT = 35729
connection = new WebSocket("ws://#{LIVERELOAD_HOST}#{LIVERELOAD_PORT}/livereload")

connection.onerror = (error)->
  console.log('reload connection got error:', error)

connection.onmessage = (e)->
  if e.data
    data = JSON.parse(e.data)
    if data and data.command == 'reload'
      chrome.runtime.reload()
