###
directives 指令
menucode 验证code的唯一性
###
angular.module('search.directives', []).
  directive('menucode',->
    {
      require: 'ngModel'
      link: (scope, elm, attrs, ctrl)->
        ctrl.$parsers.unshift((viewValue)->
          b = false
          for s in [scope.allUrls, scope.custom, scope.group]
            for m in s
              if m.c == viewValue
                b = true
          if b
            ctrl.$setValidity('menucode', false)
            return undefined
          else
            ctrl.$setValidity('menucode', true)
            return viewValue
        )
    }
  )
