###
i18nService.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###

services.factory('i18n', [
  'localStorageService'
  (lls)->
    $code = lls.get('locale')
    if not $code
      $code = 'zh_CN'

    # 取值
    getValue = (value, def)->
      if value then value else def

    # 获取翻译
    get = (key, def=key)->
      getValue(TRANSLATIONS[$code][key], def)
    {
      setLocale: (code)->
        $code = code
      locale: ->
        $code
      get: get
    }
])

