app = angular.module('popup', [
  'pascalprecht.translate'
  'popup.controllers'
  'utils.directives'
])
ctrls = angular.module('popup.controllers', [])
utilsDirectives = angular.module('utils.directives', [])
app.config([
  '$translateProvider'
  (
    $translateProvider
  )->
    for k of TRANSLATIONS['zh_CN']
      for l in LANGUAGE
        if k not of TRANSLATIONS[l]
          TRANSLATIONS[l][k] = k
    for l in LANGUAGE
      $translateProvider.translations(l, TRANSLATIONS[l])
    $translateProvider.registerAvailableLanguageKeys(LANGUAGE,
        'zh-cn': 'zh_CN'
        'zh-tw': 'zh_TW'
        'en': 'en'
        'ru': 'ru'
      )
      .determinePreferredLanguage()
      .fallbackLanguage('en')
    $translateProvider.useSanitizeValueStrategy('escaped')
])

