# 工具服务类
describe 'utilServices', ->
  beforeEach module 'utils.services'
  describe 'ls', ->
    it '获取本地存储对象', inject (ls) ->
      ls()['a'] = '1'
      expect(localStorage.a).toEqual('1')
      expect(ls().a).toEqual('1')
  # 读取
  describe 'lsGetItem', ->
    it '取值', inject (lsGetItem) ->
      localStorage['a'] = '2'
      expect(lsGetItem('a')).toEqual(2)
      expect(lsGetItem('b', '3')).toEqual('3')

  describe 'lsSetItem', ->
    it '设值', inject (lsSetItem) ->
      lsSetItem 'c', '5'
      expect(localStorage['c']).toEqual('"5"')
  describe 'boolen', ->
    it '设值', inject (lsSetItem, lsGetItem) ->
      lsSetItem 'c', true
      expect(lsGetItem('c')).toEqual(true)
      lsSetItem 'c', false
      expect(lsGetItem('c')).toEqual(false)
