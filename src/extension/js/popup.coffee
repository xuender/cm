angular.module('popup', [
  'utils.services'
  'utils.directives'
])
$ ->
  _gaq.push(['_trackEvent', 'popup', 'open'])
