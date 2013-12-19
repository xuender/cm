###
#utilsDirectives 工具指令
* enter 回车跳转或回车运行方法
* integer 整数校验
###
utilsDirectives = angular.module('utils.directives', [])
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
INTEGER_REGEXP = /^\-?\d*$/
utilsDirectives.directive('integer',->
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
