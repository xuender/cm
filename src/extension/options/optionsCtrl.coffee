###
# options controllers 控制器
###
ctrls.controller('OptionsCtrl',[
  '$scope'
  'localStorageService'
  '$translate'
  '$menu'
  'i18n'
  (
    $scope
    lls
    $translate
    $menu
    i18n
  )->
    console.log 'option ctrl'
    $scope.initLocal = ->
      $scope.locale = lls.get('locale')
      if not $scope.locale
        $scope.locale = navigator.language.replace('-', '_')
      if $scope.locale not in ['ru', 'en', 'zh_CN', 'zh_TW']
        $scope.locale = 'en'
      lls.set('locale', $scope.locale)
    $scope.$watch('locale', (n, o) ->
      lls.set('locale', n)
      i18n.setLocale n
      $translate.use(n)
      $menu.reset()
    )
    $scope.initLocal()
    #$scope.getI18n = (id)->
    #$s### i18n 字符串 ###
    #$si18n.get(id)
])
#BodyCtrl = (scope, log, http, $location, lsGetItem, lsSetItem)->
#  ### 页面控制器 ###
#  $(document).on('click', 'a', ->
#    if $(this).attr('id')
#      ga('send', 'event', 'a', $(this).attr('id'))
#    true
#  )
#  scope.isActive = (route)->
#    ### 是否是当前页 ###
#    route == $location.path()
#  for span in $('span')
#    if span.id
#      span.textContent = ci18n.getMessage(span.id)
#
#  scope.i18n = (type = null)->
#    ### 多国语言 ###
#    for es in [$('span'), $('h3'), $('button'), $('small'), $('label')]
#      for s in es
#        if s.id
#          s.textContent = ci18n.getMessage(s.id)
#    for s in $('select')
#      q = $(s)
#      q.attr('data-placeholder', ci18n.getMessage('i_select'))
#    if type
#      $('#i_t').text(ci18n.getMessage("i_#{type}"))
#      $('#i_s').text(ci18n.getMessage("i_#{type}_title"))
#      $('#i_l').text(ci18n.getMessage("i_s#{type}"))
#    1
#BodyCtrl.$inject = ['$scope', '$log', '$http', '$location', 'lsGetItem',
#  'lsSetItem']
