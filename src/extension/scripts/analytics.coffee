_gaq = _gaq || []
_gaq.push(['_setAccount', 'UA-35761644-1'])
_gaq.push(['_trackPageview'])
((i, s, o, g, r, a, m)->
  if localStorage['analytics']
    #i['GoogleAnalyticsObject'] = r
    #i[r] = i[r] || ->
    #  (i[r].q = i[r].q || []).push(arguments)
    #i[r].l = 1 * new Date()
    #a = s.createElement(o)
    #m = s.getElementsByTagName(o)[0]
    #a.async = 1
    #a.src = g
    #m.parentNode.insertBefore(a, m)
    ga = document.createElement('script')
    ga.type = 'text/javascript'
    ga.async = true
    ga.src = 'https://ssl.google-analytics.com/ga.js'
    s = document.getElementsByTagName('script')[0]
    s.parentNode.insertBefore(ga, s)
    window['ga'] = (a, b, c, d)->
      if c
        _gaq.push(['_trackEvent', c, d])
  else
    window['ga'] = ->
      console.debug arguments
)(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga')
ga('create', 'UA-35761644-1')
ga('send', 'pageview')
