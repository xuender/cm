###
# body controllers 控制器
###
#MEN = findUrls('MEN')
#LIN = findUrls('LIN')
#TXT = findUrls('TXT')
#PIC = findUrls('PIC')
BodyCtrl = (scope, log, http, $location, lsGetItem, lsSetItem)->
  ### 页面控制器 ###
  $(document).on('click', 'a', ->
    if $(this).attr('id')
      _gaq.push(['_trackEvent', 'a', $(this).attr('id')])
    true
  )
  scope.isActive = (route)->
    ### 是否是当前页 ###
    route == $location.path()
  for span in $('span')
    if span.id
      span.textContent = ci18n.getMessage(span.id)

  scope.i18n = (type = null)->
    ### 多国语言 ###
    for es in [$('span'), $('h3'), $('button'), $('small'), $('label')]
      for s in es
        if s.id
          s.textContent = ci18n.getMessage(s.id)
    for s in $('select')
      q = $(s)
      q.attr('data-placeholder', ci18n.getMessage('i_select'))
    if type
      $('#i_t').text(ci18n.getMessage("i_#{type}"))
      $('#i_s').text(ci18n.getMessage("i_#{type}_title"))
      $('#i_l').text(ci18n.getMessage("i_s#{type}"))
    1
  scope.getI18n = (id)->
    ### i18n 字符串 ###
    ci18n.getMessage(id)
  scope.loadDb = ->
    log.debug 'loadDb'
    old = lsGetItem('loadDb', 0)
    if new Date().getTime() - old > 86400000
      log.debug '获取数据'
      sa = []
      for t in ['men', 'lin', 'pic', 'txt']
        for s in lsGetItem("#{t}Select", [])
          sa.push(s)
      sa = sa.join(',')
      bs = lsGetItem('bl', []).join(',')

      queryDb((max)->
        log.debug max
        #url: 'http://localhost:8000/url/query/'
        http(
          method: 'POST'
          url: 'http://cm.xuender.me/url/query/'
          data: $.param(
            t: max
            v: sa
            b: bs
          )
        ).success((data, status, headers, config) ->
          saveDb(data)
          lsSetItem('loadDb', new Date().getTime())
          _gaq.push(['_trackEvent', 'db', 'query'])
        ).error((data, status, headers, config) ->
          log.error '错误'
          log.error data
          _gaq.push(['_trackEvent', 'db', 'query_error'])
        )
      )
  scope.loadDb()
BodyCtrl.$inject = ['$scope', '$log', '$http', '$location', 'lsGetItem',
  'lsSetItem']
