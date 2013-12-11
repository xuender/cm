angular.module('popup', [
  'utils.services'
  'utils.directives'
  'ui.bootstrap'
])
$ ->
  chrome.runtime.getBackgroundPage (backgroundPage)->
    backgroundPage.menuReset()
  _gaq.push(['_trackEvent', 'popup', 'open'])
