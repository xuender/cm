###
i18nServiceSpec.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
describe 'i18nService', ->
  beforeEach module 'LocalStorageModule'
  beforeEach module 'cm.services'
  describe 'i18n', ->
    it 'get', inject (i18n) ->
      expect(i18n.get('Context Menus')).toEqual('右键搜')
      expect(i18n.get('key')).toEqual('key')
      expect(i18n.get('key', 'def')).toEqual('def')
      i18n.setLocale('en')
      expect(i18n.get('Context Menus')).toEqual('Context Menus')
    it 'locale', inject (i18n) ->
      expect(i18n.locale()).toEqual('zh_CN')
      i18n.setLocale('en')
      expect(i18n.locale()).toEqual('en')

describe 'bootstrap', ->
  beforeEach module 'ui.bootstrap'
  describe 'modal', ->
    it 'get', inject ($modal) ->
      expect(1).toEqual(1)
