###
#utilsDirectives 工具指令
* enter 回车跳转或回车运行方法
* integer 整数校验
* json 加载JSON并显示某值
###
# 回车
utilsDirectives.directive('enter',->
  ($scope, elm, attr)->
    elm.bind('keydown', (e)->
      if e.keyCode == 13
        if attr.enter
          $scope.$apply(attr.enter)
        else
          e.preventDefault()
          nxtIdx = $('input').index(this) + 1
          $("input:eq(" + nxtIdx + ")").focus()
    )
)
# 整数
utilsDirectives.directive('integer',->
  INTEGER_REGEXP = /^\-?\d*$/
  {
    require: 'ngModel'
    link: (scope, elm, attrs, ctrl)->
      ctrl.$parsers.unshift((viewValue)->
        if (INTEGER_REGEXP.test(viewValue))
          ctrl.$setValidity('integer', true)
          return viewValue
        else
          ctrl.$setValidity('integer', false)
          return undefined
      )
  }
)

utilsDirectives.directive('json', ->
  {
    replace: true
    template: '<span>{{ value }}</span>'
    restrict: 'E'
    link: (scope, el, attrs)->
      url = attrs['url']
      if url
        xhr = new XMLHttpRequest()
        xhr.open("GET", chrome.extension.getURL(url))
        xhr.onreadystatechange = ->
          if this.readyState == 4 and this.responseText
            key = attrs['key']
            if key
              scope.value = JSON.parse(this.responseText)[key]
        try
          xhr.send()
  }
)
