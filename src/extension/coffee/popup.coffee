angular.module('popup', [
  'utils.services'
  'utils.directives'
])
$ ->
  ga('send', 'event', 'popup', 'open')
